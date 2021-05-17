"""
Away From Keyboard
version 2.0

""" 


# This Python file uses the following encoding: utf-8
from datetime import datetime
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

    def one_sec_task(self):
        pass

class Report():

    def __init__(self):
        pass
class Timer():
    time = datetime.time()

    def __init__(self, time):
        pass

    def add_time(self, time):
        pass

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
    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #Prepare backends 
    console = Console()
    backend = Backend()
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


    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())