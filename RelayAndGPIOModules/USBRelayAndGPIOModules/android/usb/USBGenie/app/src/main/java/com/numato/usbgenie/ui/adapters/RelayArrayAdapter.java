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

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;

import com.kyleduo.switchbutton.SwitchButton;
import com.norbsoft.typefacehelper.TypefaceHelper;
import com.numato.usbgenie.R;
import com.numato.usbgenie.model.devices.Relay;

public class RelayArrayAdapter extends ArrayAdapter<Relay> {

    public RelayArrayAdapter(Context context, List<Relay> objects) {
        super(context, R.layout.relay_list_row, objects);
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = LayoutInflater.from(getContext());
        View rowView = inflater.inflate(R.layout.relay_list_row, parent, false);
        TypefaceHelper.typeface(rowView);

        final Relay relay = getItem(position);
        ImageView rowImage = (ImageView) rowView.findViewById(R.id.relayRowImage);
        TextView rowText = (TextView) rowView.findViewById(R.id.relayRowText);
        final SwitchButton rowSwitch = (SwitchButton) rowView.findViewById(R.id.relayRowSwitch);

        //Set image and text for row
        rowText.setText("Relay " + Integer.toString(relay.getNumber()));

        //Get the current relay state and apply to the switch
        rowSwitch.setChecked(relay.getState());

        //Relay list view event listener
        rowSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                relay.setState(isChecked);
            }
        });

        return rowView;
    }
}
