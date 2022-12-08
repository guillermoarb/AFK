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

from PyQt5.QtGui import*
from PyQt5.QtQml import*
from PyQt5.QtCore import*


from  json_report import Report


# Constants
ONE_SECOND = 1000 # Number of miliseconds for one second loop


class State_Machine():

    one_min_task_sec_cnt = 0

    def __init__(self):
        self.state = "not_init"
        self.status_bar_counter = 0
        self.status_bar_time_limit = 0
        self.status_bar_state = 'stop'

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
        sec_increment = 1  #Set to 1 for 1 sec

        #Check exit request
        if backend.exit_app_request == True:
            backend.update_report()
            sys.exit()

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
                backend.update_task_text_ui(task_text, task_timer)
                backend.update_issue_text_ui(issue_text, issue_timer)
            else:
                pass
                #TODO Log pause items, lock time
        else:
            day_timer.add_time_sec(sec_increment)
            task_timer.add_time_sec(sec_increment)
            issue_timer.add_time_sec(sec_increment)
            # Update day timer UI
            backend.set_day_timer_text_ui(day_timer.time.strftime("%H:%M"))
            backend.update_task_text_ui(task_text, task_timer)
            backend.update_issue_text_ui(issue_text, issue_timer)

        #Call other tasks with greater times 
        if(self.one_min_task_sec_cnt >= 60):
            self.one_min_task_sec_cnt = 0
            self.one_min_task()

        # Start counting delay for status bar
        if (self.status_bar_state == 'start'):
            self.status_bar_counter = self.status_bar_counter + 1
            # Evaluate delay for status bar
            if self.status_bar_counter >= self.status_bar_time_limit:
                # Restore status_bar counter and state
                self.status_bar_state = 'stop'
                self.status_bar_counter = 0
                # Restore status bar UI
                backend.set_status_text_ui('')
                backend.set_status_color_ui('default')


    def one_min_task(self):
            backend.update_report()
            #print(day_timer)

    def status_bar_show_sec(self, text, color, time):
        if self.status_bar_state == 'stop':
            # Set UI
            backend.set_status_text_ui(text)
            backend.set_status_color_ui(color)
            # Start status bar time state and counter
            self.status_bar_state = 'start'
            self.status_bar_time_limit = time

    def one_sec_task_pause(self, pause):
        if(pause == True):
            timer_1s.stop()

        if(pause == False):
            timer_1s.start(ONE_SECOND)


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

        if hours >= 24:
            hours = 23

        self.time = datetime.time(hours,minutes,seconds)


    def subtract_time(self, time):
        pass

    def set_time(self, time):
        pass

class Console(QObject):

    @pyqtSlot(str)
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

    dayTimerSetText = pyqtSignal(str)
    projectSetText = pyqtSignal(str)
    issueSetText = pyqtSignal(str)
    taskSetText = pyqtSignal(str)
    statusSetText = pyqtSignal(str)
    statusSetColor = pyqtSignal(str)
    issueComboBoxAddItem = pyqtSignal(str)
    taskComboBoxAddItem = pyqtSignal(str)
    projectComboBoxAddItem = pyqtSignal(str)
    taskComboBoxClear = pyqtSignal()
    projectComboBoxClear = pyqtSignal()
    issueComboBoxClear = pyqtSignal()
    editDialogValidation = pyqtSignal(str)

    day_timer_pause = False
    exit_app_request = None


    #Menu mouse area click event
    @pyqtSlot()
    def menu_ma_clicked(self):
        print("Menu Clicked")

    # Task mouse area click event
    @pyqtSlot(str)
    def task_ma_clicked(self, text):
        print(f"Task clicked, contains: {text}")

    # Day timer mouse area click event
    @pyqtSlot(str)
    def day_timer_ma_clicked(self, text):
        print(f"Day timer clicked, contains: {text}")
        # Pause toggle
        if self.day_timer_pause == False:
            self.day_timer_pause = True
            # Set pause color for status
            self.set_status_text_ui('PAUSED')
            self.set_status_color_ui('#bf616a')
            # Pause one sec state machine
            state_machine.one_sec_task_pause(True)
        
        else:
            self.day_timer_pause = False
            # Set pause color for status
            self.set_status_text_ui('')
            self.set_status_color_ui('default')
            # Pause one sec state machine
            state_machine.one_sec_task_pause(False)


    # Issue mouse area click event
    @pyqtSlot(str)
    def issue_ma_clicked(self, text):
        print(f"Issue clicked, contains: {text}")

    # Project mouse area click event
    @pyqtSlot(str)
    def project_ma_clicked(self, text):
        print(f"Project mouse area clicked {text}")

    # Edit_dialog opened
    @pyqtSlot()
    def edit_dialog_opened(self):
        print(f"Edit dialog opened")
        #Populate all issues in combo box
        self.issue_combobox_clear()
        self.issue_combobox_update()

        #Populate all projects in combo box
        self.project_combobox_clear()
        self.project_combobox_update()

    @pyqtSlot()
    def edit_dialog_on_return_key(self):
        pass

    # Request from UI to exit the application
    @pyqtSlot()
    def quit_app(self):
        self.exit_app_request = True

    # Request from UI to update/save the json report
    @pyqtSlot()
    def save_all(self):
        self.update_report()

    
    def addItem_IssueCB(self, issue):
        self.issueComboBoxAddItem.emit(issue)
    
    def issue_combobox_clear(self):
        self.issueComboBoxClear.emit()

    def issue_combobox_update(self):
        issues = report.issue_get_all_names()
        print(f"Issues {issues}")

        if issues != None:
            for issue in issues:
                self.addItem_IssueCB(issue)

    def addItem_ProjectCB(self, item):
        self.projectComboBoxAddItem.emit(item)

    def project_combobox_update(self):
        projects = report.project_get_all()
        print(f"Projects {projects}")

        #Eliminate duplicates
        projects = (list(dict.fromkeys(projects)))

        for project in projects:
            self.addItem_ProjectCB(project)

    def project_combobox_clear(self):
        self.projectComboBoxClear.emit()

    def addItem_TaskCB(self, item):
        self.taskComboBoxAddItem.emit(item)

    def update_task_combobox(self, issue):
        #Clear all list model items
        self.task_combobox_clear()
        tasks = report.task_get_all_names(issue)
        print(f"Tasks {tasks}")

        if tasks != None:
            for task in tasks:
                self.addItem_TaskCB(task)

    def task_combobox_clear(self):
        self.taskComboBoxClear.emit()

    # Edit_dialog close button event
    @pyqtSlot()
    def edit_close_ma_clicked(self):
        print("Edit close clicked")
    
    @pyqtSlot(str, int)
    def issue_ma_option_clicked(self, text, idx):
        print(f"Issue combo box option selected: {text}, with index {idx}")
        #Load list model items from new issue selected
        self.update_task_combobox(text)

    @pyqtSlot(str, int)
    def project_ma_option_clicked(self, text, idx):
        print(f"Project combo box option selected: {text}, with index {idx}")
        

    @pyqtSlot(str, int)
    def task_ma_option_clicked(self, text, idx):
        print(f"Task combo box option selected: {text}, with index {idx}")

    @pyqtSlot(str)
    def issue_te_editingFinished(self, text):
        print(f"Issue Text Edit finished with {text}")
        self.update_task_combobox(text)

    @pyqtSlot(str)
    def project_te_editingFinished(self, text):
        print(f"Project Text Edit finished with {text}")

    @pyqtSlot(str)
    def task_te_editingFinished(self, text):
        print(f"Task Text Edit finished with {text}")

    # Edit_dialog update button event
    # TODO this is not working !!!
    @pyqtSlot(str, str, str)
    def edit_update_ma_clicked(self, issue, project, task):
        global project_text
        global issue_text
        global task_text

        validation_error = None
        
        print(f"Edit check clicked  {project} {issue} {task}")

        # Validate data and then set the text in the ui and set global variables

        #Validation
        #Is empty ???
        #Is a valid value ???

        if(validation_error == None):
            self.editDialogValidation.emit("None")

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
        self.update_issue_text_ui(issue_text, issue_timer)
        self.update_task_text_ui(task_text, task_timer)
        self.set_project_text_ui(project_text)
        # Update issue and project
        report.report_update_task(  task_timer.time.strftime("%H:%M:%S"), 
                                    task_text, 
                                    datetime.datetime.now().strftime("%m/%d/%y"), 
                                    issue_text )
        #Set status bar info
        state_machine.status_bar_show_sec('New info added', '#4fe7a1', 3)

    def set_day_timer_text_ui(self,s):
        self.dayTimerSetText.emit(s)

    def set_project_text_ui(self, s):
        self.projectSetText.emit(s)

    def update_issue_text_ui(self, s, timer):
        #s = self.attach_timer_to_str(s,timer)
        self.issueSetText.emit(s)

    def update_task_text_ui(self,s, timer):
        s = self.attach_timer_to_str(s,timer)
        self.taskSetText.emit(s)

    def set_status_text_ui(self,s):
        self.statusSetText.emit(s)

    def set_status_color_ui(self, s):
        # Check to restore color        
        if s == 'default':
            s = '#ECEFF4'
        # Send signal to change the color
        self.statusSetColor.emit(s)

    def update_report(self):
        #Update issue information
        report.report_set_issue(issue_text, issue_text, project_text, issue_timer.time)
        #Update task information
        report.report_update_task(  task_timer.time.strftime("%H:%M:%S"), 
                                    task_text, 
                                    datetime.datetime.now().strftime("%m/%d/%y"), 
                                    issue_text )
        
        # Update day time
        report.today_update_time(day_timer.time.strftime("%H:%M:%S"))
        # Update week time
        report.week_update_worked_time()
        # Print the report
        report.report_print_json()

    def attach_timer_to_str(self, s, timer):
        return f'{s} - {timer.time.strftime("%H:%M")}'


    # Open the json report for this week
    @pyqtSlot()
    def open_json_report_file(self):
        report.json_report_open()

    # Generate a markdown report with the actual week information
    @pyqtSlot()
    def generate_markdown_week_report(self):
        report.generate_report()


if __name__ == '__main__':
    #Init config values


    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Set app icon
    app.setWindowIcon(QIcon(os.fspath(Path(__file__).resolve().parent / "images/afk_at_garb_icon_64.png")))

    #ctypes user32 API instance
    if(sys.platform == 'win32'):
        user32 = ctypes.windll.User32

    #Prepare backends 
    report = Report()
    console = Console()
    backend = Backend()
    state_machine =State_Machine()
    # Create timers
    day_timer = Timer()
    pause_timer = Timer()
    project_timer = Timer()
    task_timer = Timer()
    issue_timer = Timer()
    #Create text labels
    day_timer_text = ""
    project_text = "Project"
    issue_text = "Issue"
    task_text = "Task"
    status_text = ""

    #This has to be in two lines, otherway it does not work
    context = engine.rootContext()
    context.setContextProperty("console", console)
    context.setContextProperty("backend", backend)

    #Load UI
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml/main.qml"))
    #engine.load("Source/away_from_keyboard/qml/main.qml")


    #Init information from report
    #Get day timer
    day_timer.time = report.today_get_time()
    # Create the day if it doesn't exist
    report.set_today()



    #Init UI
    backend.set_day_timer_text_ui("00:00")
    backend.set_project_text_ui("Project")
    backend.update_issue_text_ui("Issue", issue_timer)
    backend.update_task_text_ui("Task", task_timer)

    #Create, connect and start task timer 1 second
    timer_1s = QTimer()
    timer_1s.timeout.connect(state_machine.one_sec_task)
    timer_1s.start(ONE_SECOND)  #In miliseconds

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
