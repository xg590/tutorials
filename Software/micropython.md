# ESP8266

* Internal PULL_UP

```py
from machine import Pin
import time

# 设置按键引脚（D1=GPIO5）
btn = Pin(5, Pin.IN, Pin.PULL_UP)

# 记录状态
last_trigger_time = 0
pressed = False
debounce_ms = 50      # 短抖动过滤阈值
long_press_ms = 500   # 长按阈值

while True:
    if btn.value() == 0:  # 按键被按下（接地）
        now = time.ticks_ms()
        if not pressed:
            # 首次检测到按下，记录时间
            last_trigger_time = now
            pressed = True
        else:
            # 已经处于按下状态，检查是否达到长按时间
            if time.ticks_diff(now, last_trigger_time) > long_press_ms:
                print("hello world")
                # 防止持续触发，直到释放才允许下一次打印
                while btn.value() == 0:
                    time.sleep_ms(10)
                pressed = False
    else:
        pressed = False

    time.sleep_ms(debounce_ms)


```