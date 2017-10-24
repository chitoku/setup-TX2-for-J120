# setup-TX2-for-J120

This is to setup NVIDIA Jetson TX2 module to be used on Auvidea J120 carrier board.

The script will download the Auvidea provided "firmware" and help applying the provided patches to flash Jetson TX2 using the previously setup JetPack files.

## How to use

First, you need to flash your Jetson TX2 module with L4T 28.1 on the dev kit carrier board.

* Download [JetPack](https://developer.nvidia.com/embedded/jetpack) 
* Apply just "Flash OS Image to Target" on JetPack
  * Put Jetson TX2 Dev Kit in Force Recovery Mode by pressing "RST" button while holding down "REC" button
  * Once the flashing is done, it will boot up in Ubuntu desktop

Then, you use this script to apply Auvidea patch.

    $ cd ~
    $ git clone https://github.com/chitoku/setup-TX2-for-J120
    $ ./setup-TX2.sh
 
It will first download the patch from Auvidea website.
It will then ask you to specify the path to the JetPack binary.
You can use [Tab] key for auto-completion.
 
    Enter path to JetPack binary (JetPack-L4T-X.X-linux-x64.run): 

Once you supply the path, it will then find the "Linux_for_Tegra_tx2" directory for flashing that has been setup up JetPack.

It will copy and patch necessary files. 
 
When everything is ready, it will ask you to put Jetson TX2 Dev Kit into Force Recovery mode again. 

    Put Jetson TX2 Dev Kit into Force Recovery mode.
    (While holding REC button, press RST button)
    When ready, press [ENTER]:

Make sure Jetson TX2 is connected to the Host PC over the USB cable, shows up on lsusb, then press [Enter].

It will then take about 20 minutes to copmplete the whole flashing process.

Once done, you will see the following message and come back to the terminal.

    *** The target t186ref has been flashed successfully. ***
    Reset the board to boot from internal eMMC.
    $

Finally, you will take out the Jetson TX2 module from Jetson TX2 Dev Kit, put it on Auvidea J120.

Power on the J120 by pressing the button on the back of Ethernet port.
Once it boots up to Ubuntu desktop, make sure both USB 3.0 ports are working.
