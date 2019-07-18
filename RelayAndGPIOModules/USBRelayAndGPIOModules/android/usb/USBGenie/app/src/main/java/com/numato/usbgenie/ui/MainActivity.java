/*
Copyright [2015] [Numato Systems Private Limited]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package com.numato.usbgenie.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Toast;
import android.content.ServiceConnection;

import com.daimajia.androidanimations.library.Techniques;
import com.daimajia.androidanimations.library.YoYo;
import com.nineoldandroids.animation.Animator;
import com.numato.usbgenie.BuildConfig;
import com.numato.usbgenie.R;
import com.numato.usbgenie.business.AppConstant;
import com.numato.usbgenie.business.GeneralSettings;
import com.numato.usbgenie.drivers.UsbSerial.CdcAcmDriver;
import com.numato.usbgenie.model.devices.DevicesManager;
import com.numato.usbgenie.model.devices.NumatoDevicesHelper;
import com.numato.usbgenie.model.devices.NumatoUSBDevice;
import com.numato.usbgenie.ui.adapters.DeviceListArrayAdapter;

import butterknife.BindView;
import butterknife.OnClick;

public class MainActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener {


    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // STATIC FIELDS
    // ------------------------------------------------------------------------

    private static final String ACTION_USB_PERMISSION = "com.numato.usbgenie.USB_PERMISSION";

    // ------------------------------------------------------------------------
    // STATIC METHODS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // FIELDS
    // ------------------------------------------------------------------------

    @BindView(R.id.devices_swipe_to_refresh)
    public SwipeRefreshLayout mDevicesSwipeRefreshLayout;

    @BindView(R.id.deviceListView)
    public ListView mDeviceListView;

    @BindView(R.id.swipe_to_refresh_container)
    public LinearLayout mSwipeTorefreshContainer;

    private DevicesManager mDevicesManager;
    private DeviceListArrayAdapter mDeviceListArrayAdapter;

    /**
     * USB permission BroadcastReceiver. We only start to use the device if we have been granted the permission.
     */
    private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver() {

        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (ACTION_USB_PERMISSION.equals(action)) {
                synchronized (this) {
                    UsbDevice device = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);

                    if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                        if (device != null) {

                            Bundle deviceIndexBundle = intent.getExtras();
                            if (deviceIndexBundle == null) {
                                return;
                            }

                            int deviceIndex = deviceIndexBundle.getInt(AppConstant.EXTRA_DEVICE_INDEX);
                            startDeviceViewerActivity(deviceIndex);
                        }
                    } else {
                        Toast.makeText(MainActivity.this, getString(R.string.usb_permission_decliend), Toast.LENGTH_SHORT).show();
                    }

                    unregisterReceiver(mUsbReceiver);
                }
            }
        }
    };

    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Listen to the SwipeTorefresh events
        mDevicesSwipeRefreshLayout.setOnRefreshListener(this);

        mDevicesManager = DevicesManager.getInstance();

        mDeviceListView.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            // Get the USB device
            NumatoUSBDevice numatoUSBDevice = mDevicesManager.getDevices().get(position);

            // request USB permission for the device
            UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
            PendingIntent mPermissionIntent = PendingIntent.getBroadcast(MainActivity.this, 0,
                            new Intent(ACTION_USB_PERMISSION).putExtra(AppConstant.EXTRA_DEVICE_INDEX, position), 0);
            IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
            registerReceiver(mUsbReceiver, filter);
            manager.requestPermission(numatoUSBDevice.getDevice(), mPermissionIntent);

            }
        });

        enumerateDevices();

        /*
         * Create a new ArrayAdapter and initialize the list with it.
         */
        mDeviceListArrayAdapter = new DeviceListArrayAdapter(this, new ArrayList<NumatoUSBDevice>());
        mDeviceListView.setAdapter(mDeviceListArrayAdapter);

        listDevices();
    }


    @Override
    public void onRefresh() {
        int numDevices = enumerateDevices();

        switch (numDevices) {
            case 0:
                Toast.makeText(this, getString(R.string.lbl_no_device_found), Toast.LENGTH_SHORT).show();
                break;

            case 1:
                Toast.makeText(this, Integer.toString(numDevices) + " " + getString(R.string.lbl_device_found), Toast.LENGTH_SHORT).show();
                fadeOutView(mSwipeTorefreshContainer);

                break;

            default:
                Toast.makeText(this, Integer.toString(numDevices) + " " + getString(R.string.lbl_devices_found), Toast.LENGTH_SHORT).show();
                fadeOutView(mSwipeTorefreshContainer);
                break;
        }


        listDevices();
        mDevicesSwipeRefreshLayout.setRefreshing(false);

    }

    /**
     * Fades out the view and then makes the item to be GONE
     * @param view
     */
    private void fadeOutView(final View view) {
        //hide the pull to refresh layout
        YoYo.with(Techniques.FadeOut).withListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animation) {

            }

            @Override
            public void onAnimationEnd(Animator animation) {
                view.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationCancel(Animator animation) {

            }

            @Override
            public void onAnimationRepeat(Animator animation) {

            }
        }).duration(500).playOn(view);
    }


    /**
     * Reads the fresh list of devices and updates the adapter
     */
    private void listDevices() {
        mDeviceListArrayAdapter.clear();
        mDeviceListArrayAdapter.addAll(mDevicesManager.getDevices());
        mDeviceListArrayAdapter.notifyDataSetChanged();
    }

    /**
     * Using the Context.USB_SERVICE it enumreates all the NUMATOLAB devices
     *
     * @return the number of devices enumerated
     */
    private int enumerateDevices() {
        int index = 0;

        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
        ArrayList<UsbDevice> cdcAcmDevices = CdcAcmDriver.ListDevices(manager);

        mDevicesManager.clearDevices();

        ArrayList<Integer> supportedDevices = NumatoUSBDevice.GetSupportedProductIds();

        if(!cdcAcmDevices.isEmpty()){
            for (UsbDevice cdcAcmDevice : cdcAcmDevices){
                int vendorId = cdcAcmDevice.getVendorId();

                if(vendorId == NumatoUSBDevice.VID_NUMATOLAB && supportedDevices.contains(cdcAcmDevice.getProductId())){
                    mDevicesManager.addDevice(new NumatoUSBDevice(index, cdcAcmDevice, manager));
                    index++;
                }
            }
        }

        return index;
    }

    /**
     * Start the devices view Activity on the selected device
     *
     * @param deviceIndex
     */
    private void startDeviceViewerActivity(int deviceIndex) {
        Intent deviceViewIntent = new Intent(this, DeviceViewActivity.class);
        deviceViewIntent.putExtra(AppConstant.EXTRA_DEVICE_INDEX, deviceIndex);
        startActivity(deviceViewIntent);
        // since this is the main activity we slide it from left and out to left as well
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @OnClick(R.id.information_image_button)
    public void startInformationPage() {
        Intent infoViewIntent = new Intent(this, InfoActivity.class);
        startActivity(infoViewIntent);
        // since this is the main activity we slide it from left and out to left as well
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------
}
