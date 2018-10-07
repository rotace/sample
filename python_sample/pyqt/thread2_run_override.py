
import sys
import time
from PyQt5 import QtCore, QtGui, QtWidgets

start_time = time.time()


class Worker_1(QtCore.QThread):
    def __init__(self):
        super().__init__()

    def run(self):
        print("run: Woring Start     @ {:.5f}".format(time.time()-start_time))
        i=5
        while i>0:
            time.sleep(1)
            print("run: Woring Now       @ {:.5f}".format(time.time()-start_time))
            i -= 1

        print("run: Woring End       @ {:.5f}".format(time.time()-start_time))

        self.exec_()
    

worker_1 = Worker_1()
worker_1.start()

app = QtWidgets.QApplication(sys.argv)
dlg = QtWidgets.QMessageBox()
dlg.setText("Now, Thread Working @ {:.5f}".format(time.time()-start_time))
dlg.exec_()
