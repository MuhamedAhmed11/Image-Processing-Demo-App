## **Image-Processing-Demo-App**

#### Author:

> Mohamed Ahmed

> email: mohamed.a.abdelmonem1@gmail.com

> Linkedin profile: https://www.linkedin.com/in/mohamed-ahmed-97a3691b2/

---

## **I. Overview**

It's a Demo Desktop Application which is responsible for performing Image Processing techniques such as: Adding, Removing Noise, Detecting Edges, Filtering, Histogram, Equalizing Images.

Application requires a valid username and password to let user enters the main menu tab.

- Function Documentation of this application and how to use it, is attached to the repo

- You can download the Exe application from [here](https://drive.google.com/file/d/1oeWcyfFExvOTl8mJ4UXc9QvyX7DVDeKJ/view?usp=sharing)

---

## **II. Tools & Functions**

_1. GUI:_

> GUI is designed by GUIDE is a development environment that provides a set of tools for creating user interfaces (UIs). These tools simplify the process of laying out and
> programming UIs. In addition to providing, an easy usage (interface) to generate your
> clicking and dragging UI component such as axes, panels, buttons, text fields, sliders,
> and so on—into the layout area.

_2. GUI Programming:_

> GUIDE automatically generates a program file containing MATLAB functions that
> controls how the UI behaves. This code file provides code to initialize the UI, and it
> contains a framework for the UI callbacks. Callbacks are functions that execute when
> the user interacts with a UI component. Use the MATLAB Editor to add code to these
> callbacks

---

## **III. User Interface (UI)**

_1. Login Tab_

> For Security Reasons, user must type a valid username: Admin, and Password: 1234
> to enter a main menu

|               Login Tab                |    Login Tab - with failed message     |
| :------------------------------------: | :------------------------------------: |
| ![Login Tab ](./captures/loginTab.JPG) | ![Login Tab](./captures/loginTab2.JPG) |

&nbsp;

_2. Main Menu Tab_

> This tab includes buttons that link between menu itself and other tabs

|  Menu Tab - with welcome message   |              Menu Tab              |
| :--------------------------------: | :--------------------------------: |
| ![Login Tab ](./captures/menu.JPG) | ![Login Tab](./captures/menu2.JPG) |

&nbsp;

_3. Histogram Tab_

> This tab for displaying Histogram of browsed Image, in addition to Equalize image and displaying Histogram of Equalized Image
> ![histTab](./captures/histTab.JPG)

&nbsp;

_4. Filter Tab_
"User has two options:"

> **First:** To apply Sobel filter by entering Threshold value, and Direction even if it vertical, horizontal, or both.
> ![filterTab_sobel](./captures/filterTab_sobel.JPG) > **Second:** To apply Laplacian filter by entering alpha value, and Shape as full, same, or valid.
> ![filterTab_laplacian](./captures/filterTab_laplacian.JPG)

&nbsp;

_5. Fourier Transform:_
User can apply a Fourier Transform to an image.

> ![foureirTab](./captures/foureirTab.JPG)

&nbsp;

_6. Salt & Pepper Noise:_
User can add noise by entering density value (or leave it with its default value: 0.2), and remove it by entering two numbers for masking.

> ![salt&pepperNoise](./captures/salt&pepperNoise.JPG)

&nbsp;

_7. Periodic Noise Tab:_
User can add noise (sine, or cosine wave) in any direction x, y, or both by entering number of number value (or with its default value: 0.2), and remove it one of three methods: Notch, Band Reject, or Masking with Zeros.

> - **Notch:** > ![periodicNoise1](./captures/periodicNoise1.JPG)
> - **Band Reject:** > ![periodicNoise2](./captures/periodicNoise2.JPG)
> - **Masking with Zeros:**
>   In this method user will choose two points from Fourier of noisy image and
>   result (filtered image) will appear automatically.
>   ![periodicNoise3](./captures/periodicNoise3.JPG)

---

## IV. Features

- Friendly UI
- Handling all errors to avoid app crash
