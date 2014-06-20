#define AX_init
///AX_init(bg,spr,str,time)
//Initializes the achievement system

/*
Arguments:
bg - Achievement Background
spr - Default Achievement Icon Sprite
str - Unlock Text
time - Display Duration
*/

global.AX_achievement_numb = 0;
global.AX_achievement_bg = argument0;
global.AX_achievement_icon = argument1;
global.AX_achievement_unlock = argument2;
global.AX_achievement_duration = argument3;
global.AX_achievement_active = false;
global.AX_achievement_current = -1;
global.AX_achievement_tick = -1;
global.AX_achievement_slide = false;

#define AX_define
///AX_define(str,spr)
//Defines a new achievement

/*
Arguments:
str - Achievement Display Text
spr - Achievement Icon Sprite, -1 to use default
*/

var ind;
ind = global.AX_achievement_numb;
global.AX_achievements_data[ind,0] = argument0;
if (argument1 == -1)
    {
    global.AX_achievements_data[ind,1] = global.AX_achievement_icon;
    }
else
    {
    global.AX_achievements_data[ind,1] = argument1;
    }
global.AX_achievement_unlocked[ind] = false;
global.AX_achievement_numb += 1;

#define AX_unlock
///AX_unlock(index)
//Activates an achievement with the given index

/*
Arguments:
index - Achievement Index
*/

global.AX_achievement_slide = false;
global.AX_achievement_active = true;
global.AX_achievement_current = argument0;
global.AX_achievement_tick = 0;
global.AX_achievement_unlocked[argument0] = true;

#define AX_unlocked
///AX_unlocked(index)
//Returns whether or not the given achievement is unlocked

/*
Arguments:
index - Achievement Index to check
*/

return (global.AX_achievement_unlocked[argument0]);

#define AX_lock
///AX_lock(index)
//Locks an achievement with a given index

global.AX_achievement_unlocked[argument0] = false;

#define AX_draw
///AX_draw(xfrom,yfrom,xto,yto,spd)
//Draws the achievements on the screen

/*
Arguments:
xfrom - X Coordinate to slide from
yfrom - Y Coordinate to slide from
xto - X coordinate to slide to
yto - Y coordinate to slide to
spd - Slide speed in pixels per step
*/

if (global.AX_achievement_active)
    {
    var spd, drawx, drawy, bg, spr, bw, bh, sw, sh, str1, str2, th1, th2;
    spd = argument4;
    if (!global.AX_achievement_slide)
        {
        xfrom = argument0;
        yfrom = argument1;
        xto = argument2;
        yto = argument3;
        global.AX_slideX = xfrom;
        global.AX_slideY = yfrom;
        global.AX_achievement_slide = true;
        }
    if (global.AX_slideX > xto)
        {
        global.AX_slideX -= spd;
        while (global.AX_slideX < xto)
            {
            global.AX_slideX += 1;
            }
        }
    if (global.AX_slideX < xto)
        {
        global.AX_slideX += spd;
        while (global.AX_slideX > xto)
            {
            global.AX_slideX -= 1;
            }
        }
    if (global.AX_slideY > yto)
        {
        global.AX_slideY -= spd;
        while (global.AX_slideY < yto)
            {
            global.AX_slideY += 1;
            }
        }
    if (global.AX_slideY < yto)
        {
        global.AX_slideY += spd;
        while (global.AX_slideY > yto)
            {
            global.AX_slideY -= 1;
            }
        }
    drawx = global.AX_slideX;
    drawy = global.AX_slideY;
    bg = global.AX_achievement_bg;
    spr = global.AX_achievements_data[global.AX_achievement_current,1];
    bw = background_get_width(bg);
    bh = background_get_height(bg);
    draw_background(bg,drawx,drawy);
    sw = sprite_get_width(spr);
    sh = sprite_get_height(spr);
    draw_sprite(spr,-1,drawx+((bh-sh)/2),drawy+((bh-sh)/2));
    str1 = global.AX_achievement_unlock;
    str2 = global.AX_achievements_data[global.AX_achievement_current,0];
    th1 = string_height(str1);
    th2 = string_height(str2);
    draw_text(drawx+sw+8+((bh-sh)/2),drawy+((bh-sh)/2),str1);
    draw_text(drawx+sw+8+((bh-sh)/2),drawy+((bh-sh)/2)+(th1+5),str2);
    global.AX_achievement_tick += 1;
    if (global.AX_achievement_tick >= global.AX_achievement_duration)
        {
        xto = xfrom;
        yto = yfrom;
        if (global.AX_slideX == xfrom && global.AX_slideY = yfrom)
            {
            global.AX_achievement_active = false;
            }
        }
    }
else
    {
    global.AX_achievement_slide = false;
    }

#define AX_save
///AX_save(fname)
//Saves all currently unlocked achievements

/*
Arguments:
fname - Filename to save to
*/

var file, i;
file = file_text_open_write(argument0);
i = 0;
repeat(global.AX_achievement_numb)
    {
    file_text_write_real(file,global.AX_achievement_unlocked[i]);
    file_text_writeln(file);
    i += 1;
    }
file_text_close(file);

#define AX_load
///AX_load(fname)
//Loads saved achievements

/*
Arguments:
fname - Filename to load from
*/

if (file_exists(argument0))
    {
    var file, i;
    file = file_text_open_read(argument0);
    i = 0;
    repeat(global.AX_achievement_numb)
        {
        global.AX_achievement_unlocked[i] = file_text_read_real(file);
        file_text_readln(file);
        i += 1;
        }
    file_text_close(file);
    }

#define AX_save_ini
///AX_save_ini(fname)
//Saves all currently unlocked achievements to an INI file

/*
Arguments:
fname - Filename to save to
*/

var i;
i = 0;
ini_open(argument0);
repeat(global.AX_achievement_numb)
    {
    ini_write_real("ACHIEVEMENTS","ACHIEVEMENT"+string(i),global.AX_achievement_unlocked[i]);
    i += 1;
    }
ini_close();

#define AX_load_ini
///AX_load_ini(fname)
//Loads saved achievements from an INI file

/*
Arguments:
fname - Filename to load from
*/

if (file_exists(argument0))
    {
    var i;
    i = 0;
    ini_open(argument0);
    repeat(global.AX_achievement_numb)
        {
        global.AX_achievement_unlocked[i] = ini_read_real("ACHIEVEMENTS","ACHIEVEMENT"+string(i),false);
        i += 1;
        }
    ini_close();
    }

