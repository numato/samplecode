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
import android.widget.ImageView;
import android.widget.TextView;

import com.norbsoft.typefacehelper.TypefaceHelper;
import com.numato.usbgenie.R;
import com.numato.usbgenie.model.devices.NumatoUSBDevice;

import butterknife.BindView;
import butterknife.ButterKnife;

public class DeviceListArrayAdapter extends ArrayAdapter<NumatoUSBDevice> {


    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------

    public class ViewHolder {
        @BindView(R.id.deviceRowImage)
        public ImageView image;
        @BindView(R.id.deviceRowText)
        public TextView text;

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

    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------
    public DeviceListArrayAdapter(Context context, List<NumatoUSBDevice> objects) {
        super(context, R.layout.device_list_row, objects);
    }



    public View getView(int position, View convertView, ViewGroup parent) {

        View rowView = convertView;
        // reuse views
        if (rowView == null) {
            LayoutInflater inflater = LayoutInflater.from(getContext());
            rowView = inflater.inflate(R.layout.device_list_row, parent, false);
            TypefaceHelper.typeface(rowView);
            // configure view holder
            ViewHolder viewHolder = new ViewHolder(rowView);
            rowView.setTag(viewHolder);
        }

        ViewHolder holder = (ViewHolder) rowView.getTag();


        NumatoUSBDevice device = getItem(position);

        //Set image and text for row
        holder.text.setText(device.getName());

        return rowView;
    }
}
