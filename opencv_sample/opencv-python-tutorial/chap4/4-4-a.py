import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('opencv_logo.jpg')

##### image 1
kernel = np.ones((5,5),np.float32)/25
dst = cv2.filter2D(img,-1,kernel)

plt.subplot(121),plt.imshow(img),plt.title('Original')
plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(dst),plt.title('Averaging')
plt.xticks([]),plt.yticks([])

plt.show()

##### image 2
blur = cv2.blur(img,(5,5))

plt.subplot(121),plt.imshow(img),plt.title('Original')
plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
plt.xticks([]),plt.yticks([])

plt.show()

##### image 3
blur = cv2.GaussianBlur(img,(5,5),0)

plt.subplot(121),plt.imshow(img),plt.title('Original')
plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
plt.xticks([]),plt.yticks([])

plt.show()

##### image 4
row,col,ch=img.shape
mean = 0
var = 0.1
sigma = 15
gauss = np.random.normal(mean,sigma,(row,col,ch))
gauss = gauss.reshape(row,col,ch)
gauss = gauss.astype(np.uint8)
noisy = cv2.addWeighted(img,0.7,gauss,0.3,0)
blur = cv2.medianBlur(noisy,5)

plt.subplot(121),plt.imshow(noisy),plt.title('Original')
plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
plt.xticks([]),plt.yticks([])

plt.show()

##### image 5
blur = cv2.bilateralFilter(img,9,75,75)

plt.subplot(121),plt.imshow(img),plt.title('Original')
plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
plt.xticks([]),plt.yticks([])

plt.show()
