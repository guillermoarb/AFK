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

class State_Machine():

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
        increment = 60

        #Check if screen is not locked
        if (self.get_lock_status() == False):
            # Increment day timer
            day_timer.add_time_sec(increment)
            # Update day timer UI
            backend.set_day_timer_text_ui(day_timer.time.strftime("%H:%M"))
        else:
            pass
            #Log pause items, lock time

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

    dayTimerSetText = Signal(str)
    projectSetText = Signal(str)
    issueSetText = Signal(str)
    taskSetText = Signal(str)

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
    @Slot(str, str, str)
    def edit_check_ma_clicked(self, project, issue , task):
        print(f"Edit check clicked  {project} {issue} {task}")

        # Validate data and then set the text in the ui and set global variables

        #Validation
        #Is empty ???
        #Is a valid value ???

        self.set_project_text_ui(project)
        self.set_issue_text_ui(issue)
        self.set_task_text_ui(task)


    def set_day_timer_text_ui(self,s):
        self.dayTimerSetText.emit(s)

    def set_project_text_ui(self, s):
        self.projectSetText.emit(s)

    def set_issue_text_ui(self, s):
        self.issueSetText.emit(s)

    def set_task_text_ui(self,s):
        self.taskSetText.emit(s)

if __name__ == '__main__':
    #Init config values


    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #ctypes user32 API instance
    user32 = ctypes.windll.User32

    #Prepare backends 
    console = Console()
    backend = Backend()
    state_machine =State_Machine()
    # Create timers
    day_timer = Timer()
    pause_timer = Timer()
    task_timer = Timer()
    issue_timer = Timer()

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
    backend.set_issue_text_ui("Issue")
    backend.set_task_text_ui("Task")

    #Create, connect and start task timer 1 second
    timer_1s = QTimer()
    timer_1s.timeout.connect(state_machine.one_sec_task)
    timer_1s.start(1000)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())