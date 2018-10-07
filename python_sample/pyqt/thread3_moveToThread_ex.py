
import sys
import time
from PyQt5 import QtCore, QtGui, QtWidgets

start_time = time.time()


class Worker_1(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.continue_flag = True

    def handler_1(self):
        print("handler_1: Woring Start     @ {:.5f}".format(time.time()-start_time))
        i=5
        while i>0 and self.continue_flag:
            time.sleep(1)
            print("handler_1: Woring Now       @ {:.5f}".format(time.time()-start_time))
            QtCore.QCoreApplication.processEvents()
            i -= 1

        print("handler_1: Woring End       @ {:.5f}".format(time.time()-start_time))
    
    def handler_2(self):
        print("handler_2: Another Work     @ {:.5f}".format(time.time()-start_time))
        self.continue_flag = False


class Worker_2(QtCore.QObject):
    sigAnotherTaskDemanded = QtCore.pyqtSignal()


thread = QtCore.QThread()
worker_1 = Worker_1()
worker_2 = Worker_2()

worker_1.moveToThread(thread)
thread.started.connect(worker_1.handler_1)
worker_2.sigAnotherTaskDemanded.connect(worker_1.handler_2)


print("Order handler_1  @ {:.5f}".format(time.time()-start_time))
thread.start()
print("Order handler_2  @ {:.5f}".format(time.time()-start_time))
worker_2.sigAnotherTaskDemanded.emit()
print("Order Finish     @ {:.5f}".format(time.time()-start_time))


app = QtWidgets.QApplication(sys.argv)
dlg = QtWidgets.QMessageBox()
dlg.setText("Now, Thread Working @ {:.5f}".format(time.time()-start_time))
dlg.exec_()
