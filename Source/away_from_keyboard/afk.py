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


if __name__ == '__main__':

    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #Get console context
    console = Console()
    backend = Backend()
    #This has to be in two lines, otherway it does not work
    context = engine.rootContext()
    context.setContextProperty("console", console)
    context.setContextProperty("backend", backend)

    
    #Load UI
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml/main.qml"))



    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())