#include <stdlib.h>
#include <zephyr/kernel.h>
#include "animation.h"

LV_IMG_DECLARE(arasaka);
// LV_IMG_DECLARE(arasaka_glitch_1);
// LV_IMG_DECLARE(arasaka_glitch_2);
// LV_IMG_DECLARE(arasaka_glitch_3);
// LV_IMG_DECLARE(arasaka_glitch_4);
LV_IMG_DECLARE(arasaka_glitch_h1);
LV_IMG_DECLARE(arasaka_glitch_h2);

LV_IMG_DECLARE(corne);

const lv_img_dsc_t *arasaka_anim[] = {
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    // &arasaka_glitch_1, 
    // &arasaka_glitch_2, 
    // &arasaka_glitch_3, 
    // &arasaka_glitch_4, 
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka, &arasaka,
    &arasaka_glitch_h1, 
    &arasaka_glitch_h2, 
};

void draw_static(lv_obj_t *canvas, bool testo) {
    lv_obj_t *art = lv_img_create(canvas);
    // lv_obj_center(art);

    // int length = sizeof(anim_imgs) / sizeof(anim_imgs[0]);
    // srand(k_uptime_get_32());
    // int random_index = rand() % length;

    if (testo) {
        lv_img_set_src(art, &arasaka);
    } else {
        lv_img_set_src(art, &corne);
    }
}

void draw_animation(lv_obj_t *canvas) {
#if IS_ENABLED(CONFIG_NICE_VIEW_GEM_ANIMATION)
    lv_obj_t *art = lv_animimg_create(canvas);
    lv_obj_center(art);

    lv_animimg_set_src(art, (const void **)arasaka_anim, 24);
    lv_animimg_set_duration(art, CONFIG_NICE_VIEW_GEM_ANIMATION_MS);
    lv_animimg_set_repeat_count(art, LV_ANIM_REPEAT_INFINITE);
    lv_animimg_start(art);
#else
    lv_obj_t *art = lv_img_create(canvas);
    // lv_obj_center(art);

    // int length = sizeof(anim_imgs) / sizeof(anim_imgs[0]);
    // srand(k_uptime_get_32());
    // int random_index = rand() % length;

    lv_img_set_src(art, &corne);
#endif

    lv_obj_align(art, LV_ALIGN_TOP_LEFT, 0, 0);
}
