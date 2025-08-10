<div align="center">
  
<img width="45%" height="auto" alt="RAPK-Project-Logo" src="https://github.com/user-attachments/assets/3ac4e34c-1bad-416c-ae57-d9ac5c1376d7" />

## Rafia Advanced Platformer Kit

This is a **Godot Engine** Framework, it's fully customizable so that the games that will be made using this framework will look totally different from each other.
</div>

***

> [!Warning]
> this framework is not ready to use yet

# Installation
* Download the framework from the [Releases](https://github.com/Spy-B/R.A.P.K-Project/releases) (for now you should download the entire source code but we will release it soon)
* Create a new **clean** Project
<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-07 20-48-46" src="https://github.com/user-attachments/assets/7f46ff8c-f04c-46df-ae05-8c92f84ad126" /></p>

* Go to **AssetLib** and then click on the top right button **[Import...]**
<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-07 20-55-21" src="https://github.com/user-attachments/assets/451c752e-ef69-4729-9a36-73f7004ea683" /></p>

* Find the Zip file and then open it
<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-07 21-02-29" src="https://github.com/user-attachments/assets/7a4abc89-5488-4da5-ab54-ed01824729f6" /></p>

* Make sure to check the **[Ignore asset root]** button and then **[Install]**

<p align="center"><img width="75%" height="auto" alt="Screenshot From 2025-08-07 22-21-28" src="https://github.com/user-attachments/assets/c98459d1-a851-43c0-93f0-eea112c41030" /></p>

## Errors after installing
after installing the framework there will be some issues you need to fix in the **Project Settings** (Autoload, Input Map...)

### Fixing the Globals (Autoload)
first of all you should add the **Global** Script to the autoload go to ```Project > Project Settings > Globals```

* press on the folder icon to choose the file path

<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 00-14-24" src="https://github.com/user-attachments/assets/c7047bd4-c51e-4d3c-abe3-2c070a25e809" /></p>

* find the **Global** Script, it should be in ```res://Scripts/Global.gd```, and then Open it

<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 00-18-03" src="https://github.com/user-attachments/assets/6f7ce137-3a99-4d61-8b3c-0a8aeb10d5bb" /></p>

* after that you should click on **[Add]**

> [!Warning]
> don't change the **Node Name**

<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 00-58-03" src="https://github.com/user-attachments/assets/5b97c238-3e8d-4b3d-a451-93b7532974d7" /></p>

and that's it, now it should be right here
<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 00-21-16" src="https://github.com/user-attachments/assets/911f2449-94be-43b4-b11e-c38859588aa2" /></p>


### Fixing the Inputs
Go to ```Project > Input Map``` and then add the following actions and assign them to the keys you want

```move_right, move_left, move_up, move_down, run, jump, reload, shoot, attack, pause, restart, interact, continue, dash, super```

click on **Add New Action**, then write its name and click on Add, and reapet it with every other action

<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 00-54-56" src="https://github.com/user-attachments/assets/0aaacdbf-d0a6-46cc-b551-af7268d5fc71" /></p>

### Fixing the window Settings
* first you have to go to the Window Settings under Display, and don't forget to check this button **[Advanced Settings]**
<p align="center"><img width="85%" height="auto" alt="Screenshot From 2025-08-10 16-42-44" src="https://github.com/user-attachments/assets/c8d26799-9ade-4c27-8965-59d3944951bc" /></p>

* Now you should see new settings appear, just copy the following settings to your project and of course you can customize them the way you want.
  #### Size:
    ```Viewport Width: 1920```
    
    ```Viewport Height: 1080```
    
    ```Mode: Exclusive Fullscreen``` **(It's a must if you gonna export your game for Phones or Tablets)**
    
    ```Resizable: false``` (Optional)
    
    ```Window Width Override: 960``` (This Settings will not effect the final game)
    
    ```Window Height Override: 540``` (This Settings will not effect the final game)
    
  #### Stretch:
    ```Mode: viewport``` (this is the best option for **2D Games**)
    
    ```Aspect: expand``` (this option will expand your window to fit your screen, **It's a must if you gonna export your game for Phones or Tablets**)
    
  #### Handheld:
    ```Orientation: Sensore Landscape``` (for Phones)
***

# Usage
> [!Warning]
> There's no Documentation Available at the moment!

> [!Tip]
> as I said before this framework is not ready to use yet, so if you wanna use you should discover it yourself for now, until I fix the issues and write the Documentation
***

# Special Thanks
#### Ezra: [Youtube](https://www.youtube.com/@ezthedev) -> [EzDialogue Plugin](https://github.com/real-ezTheDev/GodotEzDialoguePlugin)
#### Marius Hanl: [Website](https://marangames.com) -> [Script IDE](https://github.com/Maran23/script-ide)
#### Leparlon : [Github Profile](https://github.com/leparlon) -> [Toast Plugin](https://github.com/leparlon/ToastPlugin)
#### Peter DV: [Github Profile](https://github.com/OrigamiDev-Pete) -> [TODO Manager](https://github.com/OrigamiDev-Pete/TODO_Manager)

***
more info soon...
