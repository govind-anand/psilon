define ['config/ico_map'], (icoMap)->

  icon: (txt)->
    @raw icoMap[txt]