1. Read picture 
2. Find features ([what is it](https://docs.opencv.org/4.x/df/d54/tutorial_py_features_meaning.html)) ([how to detect](https://docs.opencv.org/4.x/d7/d66/tutorial_feature_detection.html)) ([how to match](https://docs.opencv.org/4.x/d5/d6f/tutorial_feature_flann_matcher.html))
3. Compute consistencies between pictures (Homography Algorithm)
4. Stitching up

* pip install opencv-python-headless matplotlib

import matplotlib.pyplot as plt, cv2 as cv, numpy as np 
print(cv.__version__)

im1 = cv.imread('1.jpg', cv.IMREAD_COLOR)
im1 = cv.cvtColor(im1, cv.COLOR_BGR2RGB)
im1 = cv.resize(im1, (0,0), fx=0.2, fy=0.2) # 20%
im2 = cv.imread('2.jpg', cv.IMREAD_COLOR)
im2 = cv.cvtColor(im2, cv.COLOR_BGR2RGB)
im2 = cv.resize(im2, (0,0), fx=0.2, fy=0.2) # 20%
plt.imshow(im1)



im1_gray = cv.cvtColor(im1, cv.COLOR_RGB2GRAY)  
im2_gray = cv.cvtColor(im2, cv.COLOR_RGB2GRAY)  
 
#-- Step 1: Detect the keypoints using copyleft ORB algorithm
detector = cv.ORB_create()
keypoints1 = detector.detect(im1_gray)

#-- Draw keypoints
img_keypoints1 = np.empty_like(im1, dtype=np.uint8)
cv.drawKeypoints(im1, keypoints1, img_keypoints1)  

keypoints2 = detector.detect(im2_gray)
img_keypoints2 = np.empty_like(im2, dtype=np.uint8)
cv.drawKeypoints(im2, keypoints2, img_keypoints2)  

fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(16,16))
ax = axes[0, 0]
ax.imshow(img_keypoints1) 
ax = axes[0, 1]
ax.imshow(img_keypoints2) 

