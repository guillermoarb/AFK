"""
Away From Keyboard
version 2.0

""" 


# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, QObject, Slot, Signal



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

    #Init UI
    backend.set_day_timer_text_ui("00:00")
    backend.set_project_text_ui("Project")
    backend.set_issue_text_ui("Issue")
    backend.set_task_text_ui("Task")


    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())