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

length= 67;
width = 37;
top_height = 10;
bottom_height = 13;
thickness = 2.2;
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
usb_width = 9.5;
usb_height = 3.9;
usb_z = 2;
battery_length = 50;
battery_width = 34;
battery_height = 10;

antenna_diameter = 6.5;

module button_slit(radius, length, size) {
    linear_extrude(10) {
        difference() {
            circle(radius);
            circle(radius - size);
            square([2 * radius, radius], anchor=BACK);
        }
        left(radius) square([size, length], anchor=BACK+LEFT);
        right(radius) square([size, length], anchor=BACK+RIGHT);
    }
}

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
                left(8) up(thickness) cylinder(h=3, r1=3, r2=2, anchor=BOTTOM);
                right(8) up(thickness) cylinder(h=3, r1=3, r2=2, anchor=BOTTOM);
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
                left(10) cuboid(size=[5,1.5,5 + usb_height - rounding], anchor=BOTTOM+BACK);
                right(10) cuboid(size=[5,1.5,5 + usb_height - rounding], anchor=BOTTOM+BACK);
            }

            // back stands
            back(tracker_length * 0.5) up(rounding) {
                left(10) cuboid(size=[5,1.5,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
                right(10) cuboid(size=[5,1.5,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
            }

            // Screen platform
            fwd(tracker_length * 0.5 - 10 + thickness) rect_tube(size1=[screen_width + 2*thickness, screen_length + 2*thickness], size2=[screen_width, screen_length], wall=thickness, h=3, anchor=BOTTOM+FRONT);
        }

        fwd(tracker_length * 0.5 - 8) {
            left(6) cylinder(h=2*thickness, r=0.75);
            right(6) cylinder(h=2*thickness, r=0.75);
        }

        down(0.5) fwd(tracker_length * 0.5 - 3) {
            left(8) button_slit(3, 3, 0.5);
            right(8) button_slit(3, 3, 0.5);
        }
    }
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

            back(tracker_length * 0.5 - (tracker_length - battery_length)) up(rounding) {
                left(width * 0.5) cuboid(size=[15,2,top_height - thickness - overlap], anchor=BOTTOM+FRONT+LEFT);
                right(width * 0.5) cuboid(size=[15,2,top_height - thickness - overlap], anchor=BOTTOM+FRONT+RIGHT);
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
