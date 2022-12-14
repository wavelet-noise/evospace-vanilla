require("common")
require("materials_list")

local function fill_from_material(item, material)
    if material.page then
        item.page = material.page
    end

    if material.unit then
        item.unit = material.unit
    end

    if material.category then
        item.category = material.category
    end

    if material.unit_mul then
        item.unit_mul = material.unit_mul
    end

    if material.description_parts then
        item.description_parts = material.description_parts
    end
end

function register_materials()
    for _, material in pairs(materials) do
        -- abstract
        if material.is_abstract then
            local item = Item.get(material.name)
            item.image = Texture.find("T_"..material.name)
            item.max_count = 1
            item.page = "Misc"
            item.label_parts = {Loc.new(material["name"], "parts")}

            fill_from_material(item, material)
        end
        -- block
        if material.is_block then
            local item = Item.get(material.name .. "Block")
            item.page = "Decoration"
            item.category = "Block"
            item.image = IcoGenerator.combine(
                Texture.find("T_" .. "Block"), 
                Texture.find("T_" .. material.name),
                {}
            )

            -- local item = {
            --     class = static_item,
            --     name = material.name .. "Block",
            --     image = "T_" .. material.name .. "Block",
            --     max_count = 999,
            --     -- "Mesh": "Models/Ingot",
            --     Materials = {"Materials/" .. material.name},
            --     label_parts = {{material.name .. "Block", "parts"}},
            --     tag = "Decoration",
            --     category = "Block",
            --     item_logic = building_cube_logic,
            --     logic_json = {Block = material.name .. "Block"},
            -- }
        
            -- if material.category then
            --     item.category = material.category
            -- end
        
            -- if material.tag then
            --     item.tag = material.tag
            -- end

            local tesselator = TesselatorCube.get(material.name .. "Block")
            tesselator:set_material(Material.load("Materials/" .. material["name"]))

            local block = Block.get(material.name .. "Block")
            block.item = item
            block.tesselator = tesselator
        
            -- images.append({
            --     NewName = "T_" .. material.name .. "Block",
            --     Base = "T_" .. "Block",
            --     MulMask = "T_" .. material.name,
            --     AddMask = "T_" .. "Block" .. additive_ico,
            -- })
            -- objects_array.append({
            --     class = tesselator_cube,
            --     name = material.name .. "Block" .. tesselator,
            --     Material = "Materials/" .. material.name,
            -- })

            fill_from_material(item, material)
        end

        -- ingot
        if material.is_ingot then
            local item = Item.get(material.name .. "Ingot")
            item.image = IcoGenerator.combine(
                Texture.find("T_".."Ingot"), 
                Texture.find("T_"..material.name),
                {Texture.find("T_IngotAdditive")}
            )
            item.max_count = 32
            item.label_parts = { 
                Loc.new(material["name"].."Ingot", "parts") 
            }
            item.page = "Misc"
            item.category = "Ingot"
            -- "Mesh": "Models/Ingot",
            -- "Materials": ["Materials/" + material["name"]],

            -- if "SmeltLevel" in material and material["SmeltLevel"] <= 0:
            --     recipes_smelt.append(
            --         {
            --             "name": material["name"] + "Ingot",
            --             "Input": {
            --                 "Items": [{"name": material["name"] + "Dust", "Count": 1}],
            --             },
            --             "ResourceInput": {
            --                 "name": "Heat",
            --                 "Count": 10,
            --             },
            --             "Output": {
            --                 "Items": [{"name": material["name"] + "Ingot", "Count": 1}]
            --             },
            --             "Ticks": 200,
            --         }
            --     )

            -- recipes_macerator.append(
            --     {
            --         "name": material["name"] + "Ingot",
            --         "Input": {
            --             "Items": [
            --                 {"name": material["name"] + "Ingot", "Count": 1},
            --             ]
            --         },
            --         "ResourceInput": {"name": "Kinetic", "Count": 15},
            --         "Output": {"Items": [{"name": material["name"] + "Dust", "Count": 1}]},
            --         "Ticks": 120,
            --     }
            -- )

            fill_from_material(item, material)
        end
    end
end