
import sys
import time
from PyQt5 import QtCore, QtGui, QtWidgets

start_time = time.time()


class Worker_1(QtCore.QObject):
    def __init__(self):
        super().__init__()

    def handler_1(self):
        print("handler_1: Woring Start     @ {:.5f}".format(time.time()-start_time))
        i=5
        while i>0:
            time.sleep(1)
            print("handler_1: Woring Now       @ {:.5f}".format(time.time()-start_time))
            i -= 1

        print("handler_1: Woring End       @ {:.5f}".format(time.time()-start_time))
    

thread = QtCore.QThread()
worker_1 = Worker_1()

worker_1.moveToThread(thread)
thread.started.connect(worker_1.handler_1)

thread.start()

app = QtWidgets.QApplication(sys.argv)
dlg = QtWidgets.QMessageBox()
dlg.setText("Now, Thread Working @ {:.5f}".format(time.time()-start_time))
dlg.exec_()
