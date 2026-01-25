#pragma once

#include <lvgl.h>
#include <zmk/endpoints.h>

#define SCREEN_WIDTH 68
#define SCREEN_HEIGHT 160

#define BUFFER_SIZE 68
#define BUFFER_OFFSET_MIDDLE -44
#define BUFFER_OFFSET_BOTTOM -112

#define CANVAS_SIZE 68
#define CANVAS_COLOR_FORMAT LV_COLOR_FORMAT_L8
#define CANVAS_BUF_SIZE \
    LV_CANVAS_BUF_SIZE(CANVAS_SIZE, CANVAS_SIZE, LV_COLOR_FORMAT_GET_BPP(CANVAS_COLOR_FORMAT), \
                       LV_DRAW_BUF_STRIDE_ALIGN)

#define LVGL_BACKGROUND                                                                            \
    IS_ENABLED(CONFIG_NICE_VIEW_WIDGET_INVERTED) ? lv_color_black() : lv_color_white()
#define LVGL_FOREGROUND                                                                            \
    IS_ENABLED(CONFIG_NICE_VIEW_WIDGET_INVERTED) ? lv_color_white() : lv_color_black()

struct status_state {
    uint8_t battery;
    bool charging;
#if !IS_ENABLED(CONFIG_ZMK_SPLIT) || IS_ENABLED(CONFIG_ZMK_SPLIT_ROLE_CENTRAL)
    struct zmk_endpoint_instance selected_endpoint;
    int active_profile_index;
    bool active_profile_connected;
    bool active_profile_bonded;
    uint8_t layer_index;
    const char *layer_label;
    uint8_t wpm[10];
#else
    bool connected;
#endif
};

void to_uppercase(char *str);
void rotate_canvas(lv_obj_t *canvas);
void fill_background(lv_obj_t *canvas);
void init_rect_dsc(lv_draw_rect_dsc_t *rect_dsc, lv_color_t bg_color);
void init_line_dsc(lv_draw_line_dsc_t *line_dsc, lv_color_t color, uint8_t width);
void init_label_dsc(lv_draw_label_dsc_t *label_dsc, lv_color_t color, const lv_font_t *font,
                    lv_text_align_t align);
void canvas_draw_rect(lv_obj_t *canvas, int32_t x, int32_t y, int32_t w, int32_t h,
                      lv_draw_rect_dsc_t *rect_dsc);
void canvas_draw_text(lv_obj_t *canvas, int32_t x, int32_t y, int32_t max_w, lv_draw_label_dsc_t *label_dsc,
                      const char *text);
void canvas_draw_line(lv_obj_t *canvas, const lv_point_t *points, uint32_t point_cnt,
                      lv_draw_line_dsc_t *line_dsc);
void canvas_draw_img(lv_obj_t *canvas, int32_t x, int32_t y, const void *src,
                     lv_draw_image_dsc_t *img_dsc);