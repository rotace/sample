from PyQt5 import QtGui, QtWidgets
import sys
import designer

class Example(QtWidgets.QMainWindow, designer.Ui_MainWindow):
    def __init__(self):
        super(self.__class__,self).__init__()
        self.setupUi(self)
        self.textEdit.setText("test textEdit")

    def clicked(self):
        self.textEdit.append("clicked")

def main():
    app = QtWidgets.QApplication(sys.argv)
    form = Example()
    form.show()

    form.btn1.clicked.connect(lambda: form.clicked())
    form.btn2.clicked.connect(app.quit)

    app.exec_()

if __name__ == "__main__":
    main()
