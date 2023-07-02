return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 30,
  height = 15,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 19,
  nextobjectid = 32,
  properties = {},
  tilesets = {
    {
      name = "collision",
      firstgid = 1,
      class = "",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "tilesets/png/collision.png",
      imagewidth = 32,
      imageheight = 32,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 1,
      tiles = {}
    },
    {
      name = "cozy",
      firstgid = 2,
      class = "",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "tilesets/png/cozy.png",
      imagewidth = 512,
      imageheight = 512,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 18,
      name = "Texture",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 30,
          name = "space",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 0,
          width = 480,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {
            ["Texture"] = "map_data/Textures/space.png",
            ["vx"] = -0.004,
            ["vy"] = 0.006
          }
        }
      }
    },
    {
      type = "group",
      id = 14,
      name = "Under",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 30,
          height = 15,
          id = 10,
          name = "ground",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {},
          encoding = "lua",
          data = {
            66, 67, 68, 69, 66, 67, 68, 69, 66, 67, 68, 69, 66, 67, 66, 67, 68, 69, 0, 0, 0, 0, 0, 0, 0, 66, 67, 68, 69, 69,
            82, 83, 84, 85, 82, 83, 84, 85, 82, 83, 84, 85, 82, 83, 82, 83, 84, 85, 0, 0, 0, 0, 0, 0, 0, 82, 83, 84, 85, 85,
            98, 99, 100, 101, 98, 99, 100, 101, 98, 99, 100, 101, 98, 99, 98, 99, 130, 131, 132, 133, 130, 131, 132, 130, 131, 132, 133, 100, 101, 101,
            114, 115, 116, 117, 114, 115, 116, 117, 114, 115, 116, 117, 114, 115, 114, 115, 146, 147, 148, 149, 146, 147, 148, 146, 147, 148, 149, 116, 117, 117,
            153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3,
            169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19,
            137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3,
            153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19,
            169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3,
            137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19,
            153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3,
            169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19,
            137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 136, 137, 138, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3,
            153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 152, 153, 154, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19, 20, 21, 19,
            169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 168, 169, 170, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 30,
          height = 15,
          id = 1,
          name = "under",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {},
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 103, 0, 0, 102, 103, 0, 0, 0, 103, 206, 207, 0, 0, 0, 0, 0, 0, 0, 206, 207, 0, 0, 0,
            0, 10, 11, 0, 0, 0, 0, 119, 0, 0, 118, 119, 0, 0, 0, 119, 222, 223, 0, 0, 0, 0, 0, 0, 0, 222, 223, 119, 0, 0,
            0, 26, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 238, 239, 0, 0, 0, 0, 0, 0, 0, 238, 239, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254, 255, 0, 0, 0, 0, 0, 0, 0, 254, 255, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 150, 151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 30,
          height = 15,
          id = 3,
          name = "pianos under",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {},
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 164, 165, 166, 167, 0, 0, 0, 0, 0, 0, 0, 0, 0, 202, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 181, 182, 183, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 196, 197, 198, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 212, 213, 214, 215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 45, 46, 47, 48,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 61, 62, 63, 64,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            44, 45, 46, 47, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            60, 61, 62, 63, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 45, 46, 47, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 61, 62, 63, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 16,
      name = "NPC",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 21,
          name = "quietly",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["dir"] = "Down",
            ["zoom"] = 0.666
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "PlayerLayer",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 3,
          name = "Player",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "group",
      id = 15,
      name = "Over",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 30,
          height = 15,
          id = 8,
          name = "Over",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {},
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 202, 203, 142, 143, 0, 0, 0, 144, 145, 202, 203, 0, 0, 0,
            0, 0, 0, 0, 0, 42, 43, 0, 78, 79, 80, 81, 0, 0, 0, 0, 218, 219, 158, 159, 0, 0, 0, 160, 161, 12, 13, 14, 15, 16,
            0, 0, 0, 0, 0, 58, 59, 0, 94, 95, 96, 97, 0, 0, 0, 0, 234, 235, 174, 175, 0, 0, 0, 176, 177, 28, 29, 30, 31, 32,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 190, 191, 0, 0, 0, 192, 193, 0, 0, 0, 0, 0,
            12, 13, 14, 15, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            28, 29, 30, 31, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 13, 14, 15, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 29, 30, 31, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 134, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 12,
      name = "Texture",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      tintcolor = { 200, 50, 50, 75 },
      properties = {},
      objects = {
        {
          id = 27,
          name = "purple glow",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 960,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {
            ["Texture"] = "map_data/Textures/CozyGym-star-texture.png",
            ["vx"] = 0.05,
            ["vy"] = 0.05
          }
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 30,
      height = 15,
      id = 6,
      name = "Collision",
      class = "",
      visible = true,
      opacity = 0.48,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "Dynamic Audio",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 11,
          name = "low audio",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["File"] = "low.ogg"
          }
        },
        {
          id = 12,
          name = "mid audio",
          type = "",
          shape = "rectangle",
          x = 512,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["File"] = "mid.ogg"
          }
        },
        {
          id = 13,
          name = "high audio",
          type = "",
          shape = "rectangle",
          x = 832,
          y = 128,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["File"] = "high.ogg"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "Events",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 14,
          name = "high",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 128,
          width = 96,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["speaker1"] = "nellie",
            ["text"] = "The lows tones are now a distant memory, another time.  The high tones of this piano fill you with anticipation."
          }
        },
        {
          id = 15,
          name = "mid",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 352,
          width = 96,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["speaker1"] = "nellie",
            ["text"] = "The lows are more distant now,  and the middle tones are most prominent."
          }
        },
        {
          id = 18,
          name = "low",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 224,
          width = 96,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["speaker1"] = "nellie",
            ["text"] = "The lower tones of this piano resonate clearly here.\nYour journey stretches out before you.   There is a long road ahead."
          }
        },
        {
          id = 22,
          name = "talk with quietly-turning",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["speaker1"] = "quietly",
            ["text"] = "Welcome to my \"dynamic audio\" proof-of-concept demo for StepMania!",
            ["text2"] = "You can test it out by visitng the different pianos throughout this room.",
            ["text3"] = "Each piano is playing a unique .ogg file!  As you approach one piano, you'll hear its audio become louder, and the other two pianos' audio will be more quiet."
          }
        }
      }
    }
  }
}
