from PySide6.QtWidgets import QApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl

app = QApplication([])
view = QQuickView()
url = QUrl("Source/away_from_keyboard/main.qml")

view.setSource(url)
view.show()
app.exec_()