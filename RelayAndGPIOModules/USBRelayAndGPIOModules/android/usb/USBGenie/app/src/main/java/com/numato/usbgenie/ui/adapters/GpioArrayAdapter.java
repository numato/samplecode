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

package com.numato.usbgenie.ui.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Switch;
import android.widget.TextView;

import com.kyleduo.switchbutton.SwitchButton;
import com.norbsoft.typefacehelper.TypefaceHelper;
import com.numato.usbgenie.R;
import com.numato.usbgenie.model.devices.Gpio;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * GPIO array adapter
 */
public class GpioArrayAdapter extends ArrayAdapter<Gpio> {


    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------

    public class ViewHolder {

        @BindView(R.id.gpioRowImage)
        public ImageView rowImage;
        @BindView(R.id.gpioRowText)
        public TextView rowText;
        @BindView(R.id.gpioRowSwitch)
        public Switch rowSwitch;
        @BindView(R.id.gpioRowCheckBox)
        public CheckBox rowCheckBox;

        public ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
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

    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    public GpioArrayAdapter(Context context, List<Gpio> objects) {
        super(context, R.layout.gpio_list_row, new ArrayList<Gpio>(objects));
    }
    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------


    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = LayoutInflater.from(getContext());
        View rowView = inflater.inflate(R.layout.gpio_list_row, parent, false);
        TypefaceHelper.typeface(rowView);


        final Gpio gpio = getItem(position);
        ImageView rowImage = (ImageView) rowView.findViewById(R.id.gpioRowImage);
        TextView rowText = (TextView) rowView.findViewById(R.id.gpioRowText);
        final SwitchButton rowSwitch = (SwitchButton) rowView.findViewById(R.id.gpioRowSwitch);
        final CheckBox rowCheckBox = (CheckBox) rowView.findViewById(R.id.gpioRowCheckBox);

        //Set image and text for row
        rowText.setText("GPIO " + Integer.toString(gpio.getNumber()));

        //Get the current relay state and apply to the switch
        if (gpio.isGpioIsInput() == true) {
            rowSwitch.setChecked(gpio.getState());
            rowSwitch.setEnabled(false);
            rowCheckBox.setChecked(false);
        } else {
            rowSwitch.setEnabled(true);
            rowCheckBox.setChecked(true);
            rowSwitch.setChecked(gpio.getCurrentOutputState());
        }

        //Switch event listener
        rowSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                gpio.setState(isChecked);
                gpio.setCurrentOutputState(isChecked);
            }
        });

        //Direction checkbox event listener
        rowCheckBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

                View currentRow = (View) buttonView.getParent();
                ListView listView = (ListView) currentRow.getParent();
                final int currentPosition = listView.getPositionForView(currentRow);
                Gpio gpio = getItem(currentPosition);

                //Save teh current direction so Gpios can be included/excluded from autorefresh
                gpio.setGpioIsInput(!isChecked);

                if (isChecked == false) {
                    rowSwitch.setEnabled(false);
                } else {
                    rowSwitch.setEnabled(true);
                }
            }
        });

        return rowView;
    }
}
