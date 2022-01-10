library(hexSticker)
library(tidyverse)

imgurl <- "logo/1280px-Carbon_dioxide_3D_ball.png"

sticker(imgurl,
        package = "icoscp",
        p_size = 40,
        p_color = "black",
        h_color = "black",
        h_fill = "white",
        filename="logo.png",
        s_y = 1.5,
        p_y = 1
        )
