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

import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.util.Log;
import android.util.TypedValue;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TabHost;
import android.widget.TabWidget;
import android.widget.TextView;
import android.widget.Toast;

import com.numato.usbgenie.R;
import com.numato.usbgenie.business.AppConstant;
import com.numato.usbgenie.model.devices.DevicesManager;
import com.numato.usbgenie.model.devices.NumatoUSBDevice;
import com.numato.usbgenie.ui.adapters.AnalogArrayAdapter;
import com.numato.usbgenie.ui.adapters.GpioArrayAdapter;
import com.numato.usbgenie.ui.adapters.RelayArrayAdapter;
import com.numato.usbgenie.utils.ui.AnimatedTabHostListener;

import java.io.IOException;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * Lists the devices with their detailed information.
 */
public class DeviceViewActivity extends BaseActivity {


    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------
    private enum TAB {
        DEFAULT, GPIO, ANALOG
    }

    // ------------------------------------------------------------------------
    // STATIC FIELDS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // STATIC METHODS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // FIELDS
    // ------------------------------------------------------------------------

    @Bind(R.id.tabHostDeviceAView)
    public TabHost tabHost;

    @Bind(android.R.id.tabs)
    public TabWidget tabWidget;

    // Device manager
    private DevicesManager mDevicesManager;

    private int mCurrentDeviceIndex = 0;
    private TAB mCurrentTab = TAB.DEFAULT;
    private Handler handler = new Handler();

    /*
     * Array adapters for the tabs content
     */
    private RelayArrayAdapter mRelayArrayAdapter;
    private GpioArrayAdapter mGpioArrayAdapter;
    private AnalogArrayAdapter mAnalogArrayAdapter;

    private Runnable refresh = new Runnable() {
        @Override
        public void run() {
            if (mCurrentTab == TAB.GPIO) {
                listGpios();
            }

            if (mCurrentTab == TAB.ANALOG) {
                listAnalog();
            }

            handler.postDelayed(this, 1000);
        }
    };

    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_view);

        mDevicesManager = DevicesManager.getInstance();

        Bundle deviceIndexBundle = getIntent().getExtras();
        if (deviceIndexBundle == null) {
            return;
        }


        mCurrentDeviceIndex = deviceIndexBundle.getInt(AppConstant.EXTRA_DEVICE_INDEX);
        setTitle(mDevicesManager.get(mCurrentDeviceIndex).getName());

        setUpTabHost();
        getDeviceInfo();

        // Init relays list
        ListView relayListView = (ListView) findViewById(R.id.listViewRelays);
        mRelayArrayAdapter = new RelayArrayAdapter(this, mDevicesManager.get(mCurrentDeviceIndex).mRelays);
        relayListView.setAdapter(mRelayArrayAdapter);

        // Init GPIOs
        ListView gpioListView = (ListView) findViewById(R.id.listViewGpios);
        mGpioArrayAdapter = new GpioArrayAdapter(this, mDevicesManager.get(mCurrentDeviceIndex).mGpios);
        gpioListView.setAdapter(mGpioArrayAdapter);

        // Init analogs
        ListView analogListView = (ListView) findViewById(R.id.listViewAnalog);
        mAnalogArrayAdapter = new AnalogArrayAdapter(this, mDevicesManager.get(mCurrentDeviceIndex).mAnalogs);
        analogListView.setAdapter(mAnalogArrayAdapter);


    }

    @Override
    protected void onPause() {
        super.onPause();
        mDevicesManager.get(mCurrentDeviceIndex).close();
    }

    @Override
    protected void onStop() {
        super.onStop();
        mDevicesManager.get(mCurrentDeviceIndex).close();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mDevicesManager.get(mCurrentDeviceIndex).close();
    }

    @OnClick(R.id.btnUpdateId)
    public void changeDeviceId() {
        TextView txtDeviceSpecificId = (TextView) findViewById(R.id.txtDeviceSpecificId);
        if (txtDeviceSpecificId.getText().length() == 8) {
            mDevicesManager.get(mCurrentDeviceIndex).setDeviceSpecificId(txtDeviceSpecificId.getText().toString().substring(0, 8));
            Toast.makeText(DeviceViewActivity.this, R.string.message_refresh_device_info, Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(DeviceViewActivity.this, R.string.message_id_must_be_8_characters_long, Toast.LENGTH_SHORT).show();
        }
    }

    @NonNull
    private TabHost setUpTabHost() {
        tabHost.setup();
        tabHost.getTabWidget().setStripEnabled(false);
        tabHost.addTab(tabHost.newTabSpec(getString(R.string.tag_info)).setIndicator(getString(R.string.lbl_info)).setContent(R.id.tabInfo));
        tabHost.addTab(tabHost.newTabSpec(getString(R.string.tag_relay)).setIndicator(getString(R.string.lbl_relay)).setContent(R.id.tabRelay));
        tabHost.addTab(tabHost.newTabSpec(getString(R.string.tag_gpio)).setIndicator(getString(R.string.lbl_gpio)).setContent(R.id.tabGpio));
        tabHost.addTab(tabHost.newTabSpec(getString(R.string.tag_analog)).setIndicator(getString(R.string.lbl_analog_title)).setContent(
                        R.id.tabAnalog));
        tabHost.setOnTabChangedListener(new AnimatedTabHostListener(this, tabHost) {

            @Override
            public void onTabChanged(String tabId) {
                super.onTabChanged(tabId);
                if (tabId.equals(getString(R.string.tag_gpio))) {
                    mCurrentTab = TAB.GPIO; // GPIO tab selected
                    listGpios();
                    handler.postDelayed(refresh, 100);
                } else if (tabId.equals(getString(R.string.tag_analog))) {
                    mCurrentTab = TAB.ANALOG; //Analog tab selected
                    listAnalog();
                    handler.postDelayed(refresh, 100);
                } else {
                    mCurrentTab = TAB.DEFAULT; //Some other tab selected
                    handler.removeCallbacks(refresh);
                }
            }
        });

        // Change background
        for (int i = 0; i < tabWidget.getChildCount(); i++) {
            tabWidget.getChildAt(i).setBackgroundResource(R.drawable.tab_widget_style);
            TextView tv = (TextView) tabWidget.getChildAt(i).findViewById(android.R.id.title); //Unselected Tabs
            tv.setTextColor(getResources().getColor(R.color.text_light));
            tv.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimension(R.dimen.text_size_small));
        }

        return tabHost;
    }


    public boolean getDeviceInfo() {

        //Firmware on Info page
        String firmwareVersion = mDevicesManager.get(mCurrentDeviceIndex).getFirmwareVersion();
        if (firmwareVersion == null) {
            Toast.makeText(DeviceViewActivity.this, R.string.message_failed_to_read_device_version, Toast.LENGTH_SHORT).show();
            firmwareVersion = getString(R.string.default_missing_value);
        }

        TextView lblFwVerison = (TextView) findViewById(R.id.lblFwVerison);
        lblFwVerison.setText(getString(R.string.firmware_version) + " " + firmwareVersion);


        //Device specific ID on Info page (The ID set/retrieved using id get/set commands)
        String deviceId = mDevicesManager.get(mCurrentDeviceIndex).getDeviceSpecificId();
        if (deviceId == null) {
            Toast.makeText(DeviceViewActivity.this, R.string.message_failed_to_read_device_id, Toast.LENGTH_SHORT).show();
            deviceId = getString(R.string.default_missing_value);

        } else {
            EditText txtDeviceSpecificId = (EditText) findViewById(R.id.txtDeviceSpecificId);
            txtDeviceSpecificId.setText(deviceId);
        }

        TextView lblDeviceID = (TextView) findViewById(R.id.lblDeviceID);
        lblDeviceID.setText(getString(R.string.device_id) + " " + deviceId);


        //USB Vendor ID on Info page
        TextView lblUsbVendorId = (TextView) findViewById(R.id.lblUsbVendorId);
        lblUsbVendorId.setText(getString(R.string.usb_vendor_id) + " " + AppConstant.DEFAULT_VENDOR_ID);

        //USB Product ID on Info page
        TextView lblUsbProductId = (TextView) findViewById(R.id.lblUsbProductId);
        lblUsbProductId.setText(getString(R.string.usb_product_id) +
                        " 0x" + Integer.toHexString(mDevicesManager.get(mCurrentDeviceIndex).getProductId()).toUpperCase());

        //Device Name on Info page
        TextView lblDeviceName = (TextView) findViewById(R.id.lblDeviceName);
        lblDeviceName.setText(getString(R.string.lbl_name) + " " + mDevicesManager.get(mCurrentDeviceIndex).getName());


        //make sure the text view doesn't grab focus
        LinearLayout dummyLayout = (LinearLayout) findViewById(R.id.dummyLayout);
        dummyLayout.requestFocus();

        return true;
    }

    /**
     * Refreshed the list of relays
     */
    private void listRelays() {
        mRelayArrayAdapter.clear();
        mRelayArrayAdapter.addAll(mDevicesManager.get(mCurrentDeviceIndex).mRelays);
        mRelayArrayAdapter.clear();
    }

    /**
     * Refreshes the list of gpios
     */
    public void listGpios() {
        mGpioArrayAdapter.clear();
        mGpioArrayAdapter.addAll(mDevicesManager.get(mCurrentDeviceIndex).mGpios);
        mGpioArrayAdapter.notifyDataSetChanged();
    }

    /**
     * Refreshes the list of analog devices
     */
    public void listAnalog() {
        mAnalogArrayAdapter.clear();
        mAnalogArrayAdapter.addAll(mDevicesManager.get(mCurrentDeviceIndex).mAnalogs);
        mAnalogArrayAdapter.notifyDataSetChanged();
    }


}
