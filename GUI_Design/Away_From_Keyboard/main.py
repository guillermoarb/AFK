# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load("Main_Window.ui.qml")



    if not engine.rootObjects():
        sys.exit(-1)
    
    print("Running")

    sys.exit(app.exec_())
