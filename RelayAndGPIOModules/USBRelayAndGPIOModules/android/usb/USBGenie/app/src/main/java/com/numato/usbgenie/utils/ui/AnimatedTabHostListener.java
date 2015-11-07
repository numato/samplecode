package com.numato.usbgenie.utils.ui;

import android.content.Context;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.TabHost;

/**
 * A custom OnTabChangeListener that uses the TabHost its related to to fetch information about the current and previous
 * tabs. It uses this information to perform some custom animations that slide the tabs in and out from left and right.
 *
 * @author Daniel Kvist
 *
 */
public class AnimatedTabHostListener implements TabHost.OnTabChangeListener
{

    private static final int ANIMATION_TIME = 240;
    private TabHost tabHost;
    private View previousView;
    private View currentView;
    private GestureDetector gestureDetector;
    private int currentTab;

    /**
     * Constructor that takes the TabHost as a parameter and sets previousView to the currentView at instantiation
     *
     * @param context
     * @param tabHost
     */
    public AnimatedTabHostListener(Context context, TabHost tabHost)
    {
        this.tabHost = tabHost;
        this.previousView = tabHost.getCurrentView();
        gestureDetector = new GestureDetector(context, new MyGestureDetector());
        tabHost.setOnTouchListener(new View.OnTouchListener()
        {
            public boolean onTouch(View v, MotionEvent event)
            {
                if (gestureDetector.onTouchEvent(event))
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        });
    }

    /**
     * When tabs change we fetch the current view that we are animating to and animate it and the previous view in the
     * appropriate directions.
     */
    @Override
    public void onTabChanged(String tabId)
    {

        currentView = tabHost.getCurrentView();
        if (tabHost.getCurrentTab() > currentTab)
        {
            previousView.setAnimation(outToLeftAnimation());
            currentView.setAnimation(inFromRightAnimation());
        }
        else
        {
            previousView.setAnimation(outToRightAnimation());
            currentView.setAnimation(inFromLeftAnimation());
        }
        previousView = currentView;
        currentTab = tabHost.getCurrentTab();

    }

    /**
     * Custom animation that animates in from right
     *
     * @return Animation the Animation object
     */
    private Animation inFromRightAnimation()
    {
        Animation inFromRight = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, 1.0f,
                        Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT,
                        0.0f);
        return setProperties(inFromRight);
    }

    /**
     * Custom animation that animates out to the right
     *
     * @return Animation the Animation object
     */
    private Animation outToRightAnimation()
    {
        Animation outToRight = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT,
                        1.0f, Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT, 0.0f);
        return setProperties(outToRight);
    }

    /**
     * Custom animation that animates in from left
     *
     * @return Animation the Animation object
     */
    private Animation inFromLeftAnimation()
    {
        Animation inFromLeft = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, -1.0f,
                        Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT,
                        0.0f);
        return setProperties(inFromLeft);
    }

    /**
     * Custom animation that animates out to the left
     *
     * @return Animation the Animation object
     */
    private Animation outToLeftAnimation()
    {
        Animation outtoLeft = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT,
                        -1.0f, Animation.RELATIVE_TO_PARENT, 0.0f, Animation.RELATIVE_TO_PARENT, 0.0f);
        return setProperties(outtoLeft);
    }

    /**
     * Helper method that sets some common properties
     *
     * @param animation
     *            the animation to give common properties
     * @return the animation with common properties
     */
    private Animation setProperties(Animation animation)
    {
        animation.setDuration(ANIMATION_TIME);
        animation.setInterpolator(new AccelerateInterpolator());
        return animation;
    }

    /**
     * A gesture listener that listens for a left or right swipe and uses the swip gesture to navigate a TabHost that
     * uses an AnimatedTabHost listener.
     *
     * @author Daniel Kvist
     *
     */
    class MyGestureDetector extends GestureDetector.SimpleOnGestureListener
    {
        private static final int SWIPE_MIN_DISTANCE = 120;
        private static final int SWIPE_MAX_OFF_PATH = 250;
        private static final int SWIPE_THRESHOLD_VELOCITY = 200;
        private int maxTabs;

        /**
         * An empty constructor that uses the tabhosts content view to decide how many tabs there are.
         */
        public MyGestureDetector()
        {
            maxTabs = tabHost.getTabContentView().getChildCount();
        }

        /**
         * Listens for the onFling event and performs some calculations between the touch down point and the touch up
         * point. It then uses that information to calculate if the swipe was long enough. It also uses the swiping
         * velocity to decide if it was a "true" swipe or just some random touching.
         */
        @Override
        public boolean onFling(MotionEvent event1, MotionEvent event2, float velocityX, float velocityY)
        {
            int newTab = 0;
            if (Math.abs(event1.getY() - event2.getY()) > SWIPE_MAX_OFF_PATH)
            {
                return false;
            }
            if (event1.getX() - event2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY)
            {
                // Swipe right to left
                newTab = currentTab + 1;
            }
            else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE
                        && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY)
            {
                // Swipe left to right
                newTab = currentTab - 1;
            }
            if (newTab < 0 || newTab > (maxTabs - 1))
            {
                return false;
            }
            tabHost.setCurrentTab(newTab);
            return super.onFling(event1, event2, velocityX, velocityY);
        }
    }
}
