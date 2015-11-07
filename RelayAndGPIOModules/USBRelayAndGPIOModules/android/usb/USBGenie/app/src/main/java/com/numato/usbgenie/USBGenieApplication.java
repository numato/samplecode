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

package com.numato.usbgenie;

import android.app.Application;
import android.graphics.Typeface;

import com.joanzapata.iconify.Iconify;
import com.joanzapata.iconify.fonts.IoniconsModule;
import com.norbsoft.typefacehelper.TypefaceCollection;
import com.norbsoft.typefacehelper.TypefaceHelper;

/**
 * The application class of the USBGenie Application
 * Created by becze on 10/13/2015.
 */
public class USBGenieApplication extends Application {

    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------

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

    @Override
    public void onCreate() {
        super.onCreate();

        // Initialize the custom font library
        //@formatter:off
        // Initialize typeface helper
        TypefaceCollection typeface = new TypefaceCollection.Builder()
                .set(Typeface.NORMAL, Typeface.createFromAsset(getAssets(), "fonts/Roboto-Light.ttf"))
                .set(Typeface.BOLD, Typeface.createFromAsset(getAssets(), "fonts/Roboto-Medium.ttf"))
                .create();
        TypefaceHelper.init(typeface);
        //@formatter:on

        // Iconify - font icon library
        Iconify.with(new IoniconsModule());
    }


    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------
}
