# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    activity_timer_lb = engine.rootObjects()[0].findChild(QObject, "app_container")
    print(type(activity_timer_lb[0]))
    activity_timer_lb.setContexProperty("color", "0xFFFFFF")

    sys.exit(app.exec_())


"""

import os
import sys
from PyQt5 import QtCore, QtGui, QtQml
from functools import partial

def testing(r):
    import random
    w = r.property("width")
    h = r.property("height")
    print("width: {}, height: {}".format(w, h))
    r.setProperty("width", random.randint(100, 400))
    r.setProperty("height", random.randint(100, 400))

def run():
    myApp = QtGui.QGuiApplication(sys.argv)
    myEngine = QtQml.QQmlApplicationEngine()
    directory = os.path.dirname(os.path.abspath(__file__))
    myEngine.load(QtCore.QUrl.fromLocalFile(os.path.join(directory, 'main.qml')))
    if not myEngine.rootObjects():
        return -1
    r = myEngine.rootObjects()[0].findChild(QtCore.QObject, "foo_object")
    timer = QtCore.QTimer(interval=500)
    timer.timeout.connect(partial(testing, r))
    timer.start()
    return myApp.exec_()

if __name__ == "__main__":
    sys.exit(run())

"""