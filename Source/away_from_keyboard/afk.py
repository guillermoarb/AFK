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


if __name__ == '__main__':

    #Create the app and QML engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #Get console context
    console = Console()
    context = engine.rootContext()
    context.setContextProperty("console", console)

    
    #Load UI
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml/main.qml"))



    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())