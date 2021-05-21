"""
Away From Keyboard
version 2.0

""" 


# This Python file uses the following encoding: utf-8
import ctypes
import datetime
import os
from pathlib import Path
import sys
from typing import List

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QTimer, QObject, QUrl, Slot, Signal

from  json_report import Report

class State_Machine():

    one_min_task_sec_cnt = 0

    def __init__(self):
        self.state = "not_init"

    def get_lock_status(self):
        #Get foreground window ID
        foreground_window = user32.GetForegroundWindow() 
        #Get foreground window text 
        window_text_len = user32.GetWindowTextLengthW(foreground_window)
        window_text = ctypes.create_unicode_buffer(window_text_len + 1)
    
        user32.GetWindowTextW(foreground_window, window_text, window_text_len + 1)
        #Evaluate if the PC is locked and then increase the right timer
        if ((foreground_window == 0) or (window_text.value == "Windows Default Lock Screen")):
            lock_status = True
        else:
            lock_status = False

        return lock_status

    def one_sec_task(self):
        sec_increment = 15  #Set to 1 for 1 sec

        # Increment counters
        self.one_min_task_sec_cnt = self.one_min_task_sec_cnt + sec_increment

        if(sys.platform == 'win32'):
            #Check if screen is not locked
            if (self.get_lock_status() == False):
                # sec_Increment day timer
                day_timer.add_time_sec(sec_increment)
                task_timer.add_time_sec(sec_increment)
                issue_timer.add_time_sec(sec_increment)
                # Update day timer UI
                backend.set_day_timer_text_ui(day_timer.time.strftime("%H:%M"))
            else:
                pass
                #Log pause items, lock time
        else:
            day_timer.add_time_sec(sec_increment)
            task_timer.add_time_sec(sec_increment)
            issue_timer.add_time_sec(sec_increment)
            # Update day timer UI
            backend.set_day_timer_text_ui(day_timer.time.strftime("%H:%M"))
            backend.set_task_text_ui(task_text, task_timer)
            backend.set_issue_text_ui(issue_text, issue_timer)

        #Call other tasks with greater times 
        if(self.one_min_task_sec_cnt >= 60):
            self.one_min_task_sec_cnt = 0
            self.one_min_task()


    def one_min_task(self):
            backend.update_report()
            print(day_timer)

class Timer():

    time = datetime.time()

    def __str__(self):
        return self.time.strftime("%H:%M:%S")

    def __init__(self):
        pass

    def add_time_sec(self, plus_seconds):
        seconds = self.time.second
        minutes = self.time.minute
        hours = self.time.hour

        seconds = seconds + plus_seconds

        if (seconds >= 60):
            minutes = minutes + 1
            seconds = 0

        if (minutes >= 60):
                hours = hours + 1
                minutes = 0

        self.time = datetime.time(hours,minutes,seconds)


    def subtract_time(self, time):
        pass

    def set_time(self, time):
        pass

class Console(QObject):

    @Slot(str)
    def outputInt(self, s):
        print(s)


class Backend(QObject):
    global project_text
    global issue_text
    global task_text
    global day_timer 
    global pause_timer 
    global project_timer 
    global task_timer 
    global issue_timer 

    dayTimerSetText = Signal(str)
    projectSetText = Signal(str)
    issueSetText = Signal(str)
    taskSetText = Signal(str)
    statusSetText = Signal(str)
    statusSetColor = Signal(str)

    #Menu mouse area click event
    @Slot()
    def menu_ma_clicked(self):
        print("Menu Clicked")

    # Task mouse area click event
    @Slot(str)
    def task_ma_clicked(self, text):
        print(f"Task clicked, contains: {text}")

    # Day timer mouse area click event
    @Slot(str)
    def day_timer_ma_clicked(self, text):
        print(f"Day timer clicked, contains: {text}")

    # Issue mouse area click event
    @Slot(str)
    def issue_ma_clicked(self, text):
        print(f"Issue clicked, contains: {text}")

    # Project mouse area click event
    @Slot(str)
    def project_ma_clicked(self, text):
        print(f"Project mouse area clicked {text}")

    # Edit dialog close button event
    @Slot()
    def edit_close_ma_clicked(self):
        print("Edit close clicked")
    
    # Edit dialog check button event
    # TODO this is not working !!!
    @Slot(str, str, str)
    def edit_check_ma_clicked(self, project, issue , task):
        global project_text
        global issue_text
        global task_text 
        
        print(f"Edit check clicked  {project} {issue} {task}")

        # Validate data and then set the text in the ui and set global variables

        #Validation
        #Is empty ???
        #Is a valid value ???

        # Is it a new issue ???
        if(report.issue_get_idx(issue)  == None):
            #Update backend
            issue_text = issue
            issue_timer.time = issue_timer.time.replace(0,0,0)
            task_text = task
            task_timer.time = task_timer.time.replace(0,0,0)
            project_text = project
            project_timer.time = project_timer.time.replace(0,0,0)

            #Add the issue here
            report.report_add_issue(issue_text, project_text, issue_timer.time.strftime("%H:%M:%S"))

        else:

            # Not new issue, but is a valid issue, update
            issue_text = issue
            task_text = task

            #Not new issue, update info
            # Evaluate a change of project for the issue
            report_project = report.issue_get_project(issue)

            if ((report_project != None) and (report_project != project)):
                # Update backend
                project_text = project

            issue_timer.time = report.report_get_issue_time(issue)
            report.report_set_issue(issue_text, issue_text, project_text, issue_timer.time)


            # The task is new
            if(report.issue_task_get_idx(issue, task) == None):
                # New task clear the timer
                task_timer.time = task_timer.time.replace(0,0,0)

            # The task is not new, continue with logged time
            else:
                task_timer.time = report.report_get_task_time(issue, task)


        # Update UI
        self.set_issue_text_ui(issue_text, issue_timer)
        self.set_task_text_ui(task_text, task_timer)
        self.set_project_text_ui(project_text)
        # Update issue and project
        report.report_update_task(  task_timer.time.strftime("%H:%M:%S"), 
                                    task_text, 
                                    datetime.datetime.now().strftime("%m/%d/%y"), 
                                    issue_text )

        self.set_status_text_ui("Added new info")
        self.set_status_color_ui("#BF616A")

    def set_day_timer_text_ui(self,s):
        self.dayTimerSetText.emit(s)

    def set_project_text_ui(self, s):
        self.projectSetText.emit(s)

    def set_issue_text_ui(self, s, timer):
        s = self.attach_timer_to_str(s,timer)
        self.issueSetText.emit(s)

    def set_task_text_ui(self,s, timer):
        s = self.attach_timer_to_str(s,timer)
        self.taskSetText.emit(s)

    def set_status_text_ui(self,s):
        self.statusSetText.emit(s)

    def set_status_color_ui(self, s):
        self.statusSetColor.emit(s)

    def update_report(self):

        report.report_add_issue(issue_text, project_text, issue_timer.time.strftime("%H:%M:%S"))

        report.report_update_task(  task_timer.time.strftime("%H:%M:%S"), 
                                    task_text, 
                                    datetime.datetime.now().strftime("%m/%d/%y"), 
                                    issue_text )

#        report.report_update_week()
#        report.report_update_worked_time()
#        report.report_update_day(day_timer.time.strftime("%H:%M:%S"))
        report.report_print_json()

    def attach_timer_to_str(self, s, timer):
        return f'{s} - {timer.time.strftime("%H:%M")}'

if __name__ == '__main__':
    #Init config values


    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #ctypes user32 API instance
    if(sys.platform == 'win32'):
        user32 = ctypes.windll.User32

    #Prepare backends 
    console = Console()
    backend = Backend()
    state_machine =State_Machine()
    report = Report()
    # Create timers
    day_timer = Timer()
    pause_timer = Timer()
    project_timer = Timer()
    task_timer = Timer()
    issue_timer = Timer()
    #Create text labels
    day_timer_text = ""
    project_text = "pt_01"
    issue_text = "it_01"
    task_text = "tt_01"
    status_text = ""

    #This has to be in two lines, otherway it does not work
    context = engine.rootContext()
    context.setContextProperty("console", console)
    context.setContextProperty("backend", backend)

    #Load UI
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml/main.qml"))
    #engine.load("Source/away_from_keyboard/qml/main.qml")


    #Init UI
    backend.set_day_timer_text_ui("00:00")
    backend.set_project_text_ui("Project")
    backend.set_issue_text_ui("Issue", issue_timer)
    backend.set_task_text_ui("Task", task_timer)

    #Create, connect and start task timer 1 second
    timer_1s = QTimer()
    timer_1s.timeout.connect(state_machine.one_sec_task)
    timer_1s.start(1000)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
