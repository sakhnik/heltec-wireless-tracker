include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 96;

// corner definition
//
cut = 1.5;
k=.7;
rounding = 2;

// snugness of the fit
delta=.15;

length = 80;
width = 40;
top_height = 10;
bottom_height = 18;
thickness = 3.2;
overlap = 3;

tracker_length = 63.64;
tracker_width = 28;
tracker_height = 8.62;
wifi_antenna_height = 1.1;

screen_width = 12;
screen_length = 23;

gnss_width = 20;
gnss_height = 0.75;

usb_hang = 2.2;
usb_width = 9;
usb_height = 3.5;
usb_z = 2;
battery_length = 50;
battery_width = 34;
battery_height = 10;

antenna_diameter = 6.9;

module top_shell() {
    difference() {
        cuboid(size=[width, length, top_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        up(thickness) cuboid([width-thickness,length-thickness,top_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        up(top_height - overlap) cuboid([width-thickness*0.5,length-thickness*0.5,top_height], anchor=BOTTOM, rounding=rounding, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
    }
}

module usbc() {
    fwd(length/2) cuboid($fn=20,[usb_width, 20, usb_height], rounding=1.4, anchor=BOTTOM);
}

module case() {
    difference() {
        union() {
            difference() {
                top_shell();

                // Usb-C
                up(thickness + usb_z) usbc();

                // Screen window
                fwd(tracker_length * 0.5 - 10 + thickness) down(0.01) prismoid(size1=[screen_width + 2*thickness, screen_length + 2*thickness], size2=[screen_width, screen_length], h=4, anchor=BOTTOM+FRONT);
            }

            // Buttons
            fwd(tracker_length * 0.5 - 3) {
                left(8) up(thickness) cylinder(h=2, r1=5, r2=2, anchor=BOTTOM);
                right(8) up(thickness) cylinder(h=2, r1=5, r2=2, anchor=BOTTOM);
            }

            // PCB stands
            fwd(tracker_length * 0.37) {
                left(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+LEFT);
                right(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+RIGHT);
            }
            back(tracker_length * 0.37) {
                left(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+LEFT);
                right(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+RIGHT);
            }

            // front stands
            fwd(tracker_length * 0.5) up(rounding) {
                left(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+BACK);
                right(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+BACK);
            }

            // back stands
            back(tracker_length * 0.5) up(rounding) {
                left(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
                right(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
            }

            // Screen platform
            fwd(tracker_length * 0.5 - 10 + thickness) rect_tube(size1=[screen_width + 2*thickness, screen_length + 2*thickness], size2=[screen_width + thickness, screen_length + thickness], wall=thickness, h=4, anchor=BOTTOM+FRONT);
        }

        // LED windows
        fwd(tracker_length * 0.5 - 8) {
            left(6) cylinder(h=5*thickness, r=1.72, anchor=CENTER);
            right(6) cylinder(h=5*thickness, r=1.72, anchor=CENTER);
        }

        // Button holes
        down(0.5) fwd(tracker_length * 0.5 - 3) {
            left(8) {
                cylinder(r1=4, r2=1, h=3, anchor=BOTTOM);
                cylinder(r=1.5, h=10, anchor=BOTTOM);
            }
            right(8) {
                cylinder(r1=4, r2=1, h=3, anchor=BOTTOM);
                cylinder(r=1.5, h=10, anchor=BOTTOM);
            }
        }
    }
}

module button() {
    cylinder(h=1.5, r=2, anchor=BOTTOM);
    up(1.5) cylinder(h=3, r=1, anchor=BOTTOM);
}

module lid() {
    difference() {
        union() {
            difference() {
                cuboid(size=[width, length, bottom_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
                up(thickness) cuboid([width-thickness,length-thickness,bottom_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
                up(top_height + bottom_height - overlap) yrot(180) {
                    top_shell();
                    scale([1.01, 1.01, 1]) top_shell();
                }

                // A hole for USB
                up(bottom_height - (top_height - thickness - usb_height - usb_z)) usbc();

                // A hole for the front stands
                fwd(tracker_length * 0.5) up(bottom_height - (overlap - 1)) {
                    left(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                    right(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                }

                // A hole for the back stands
                back(tracker_length * 0.5) up(bottom_height - (overlap - 1)) {
                    left(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                    right(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                }
            }

            // Battery support
            back(battery_length - length * 0.5 + 10) up(rounding) {
                left(width * 0.5) cuboid(size=[15,3,bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+LEFT);
                right(width * 0.5) cuboid(size=[15,3,bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+RIGHT);
            }

            fwd(length * 0.5 - 10) up(rounding) {
                left(width * 0.5) cuboid(size=[10,3,bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+LEFT);
                right(width * 0.5) cuboid(size=[10,3,bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+RIGHT);
            }

            // Antenna support
            bulge_thickness = 1;
            back(length*0.5 - bulge_thickness) hull() {
                up(bottom_height/2) xrot(90) cylinder(h=bulge_thickness, r=antenna_diameter/2 + 1);
                up(thickness) cuboid(size=[antenna_diameter + 2, 1, 3], anchor=BOTTOM+BACK);
            }
        }

        // Antenna
        up(bottom_height/2) back(length*0.5 + 10) xrot(90) cylinder(h=20, r=antenna_diameter/2);
    }
}

case();

right(50) lid();
left(30) button();
left(40) button();
