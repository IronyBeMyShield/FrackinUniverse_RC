local recipes =
{
--  inputs = {{item = "lolitem",amount =3}, {item = "lolitem2", amount = 4}}   go like that if you want multiples

-- basic materials
{inputs = {"irradiumore" },{"irradiumore" },{"irradiumore" }, outputs = { "irradiumbar" }, time = 4},

{inputs = {"glassmaterial", "rawminerals", "nutrientpaste" }, outputs = { "mineralsample" }, time = 15},
{inputs = {"glassmaterial", "geneticmaterial", "tissueculture" }, outputs = { "dnasample" }, time = 15},
{inputs = {"mineralsample", "dnasample", "biochipbase" }, outputs = { "biochip" }, time = 30},
{inputs = {"glassmaterial", "protocitebar", "dnasample" }, outputs = { "vialproto", "vialproto" }, time = 30},
{inputs = {"moonstoneore", "blisterbushplantfood", "dnasample" }, outputs = { "blisterextract", "blisterextract" }, time = 30},
{inputs = {"mineralsample", "mutavisksilk", "dnasample" }, outputs = { "mutaviskthread", "mutaviskthread" }, time = 20},
{inputs = {"prisilitestar", "protorockmaterial", "mineralsample" }, outputs = { "aliencompound" }, time = 5},
{inputs = {"methanol", "iodine", "phosphorus" }, outputs = { "methyliodide" }, time = 5},
{inputs = {"coalore", "liquidwater", "ff_silicon" }, outputs = { "graphene" }, time = 15},

-- armor, weapons etc
{inputs = {"blisterchest", "goldenglowseed", "penumbriteshard" }, outputs = { "blisterchestalt-recipe" }, time = 120},
{inputs = {"blisterpants", "goldenglowseed", "penumbriteshard" }, outputs = { "blisterpantsalt-recipe" }, time = 120},
{inputs = {"blisterhelm", "goldenglowseed", "penumbriteshard" }, outputs = { "blisterhelmalt-recipe" }, time = 120},
{inputs = {"blisterhelm2", "goldenglowseed", "penumbriteshard" }, outputs = { "blisterhelmalt-recipe" }, time = 120},
{inputs = {"ff_scouthelm", "penumbraplating", "diamond" }, outputs = { "skullreaperhelm-recipe" }, time = 120},
{inputs = {"spikesword", "protocitebar", "cellmatter" }, outputs = { "spikesword2-recipe" }, time = 120},
{inputs = {"spikesword2", "ff_penumbraplating", "cellmatter" }, outputs = { "spikesword3-recipe" }, time = 120},
{inputs = {"spikesword3", "uraniumrod", "cellmatter" }, outputs = { "spikesword4-recipe" }, time = 120},
{inputs = {"spikesword4", "prisilitestar", "cellmatter" }, outputs = { "spikesword5-recipe" }, time = 120},
{inputs = {"ff_scoutchest", "ff_mercury", "ff_penumbraplating" }, outputs = { "ff_scoutchest_melee-recipe" }, time = 120},
{inputs = {"ff_scouthelm", "ff_mercury", "ff_penumbraplating" }, outputs = { "ff_scouthelm_melee-recipe" }, time = 120},
{inputs = {"ff_scoutpants", "ff_mercury", "ff_penumbraplating" }, outputs = { "ff_scoutpants_melee-recipe" }, time = 120}



--  *************
--  add random chance to drop higher or lower quality versions of samples? rares? etc?
--  *************
-- local.samplingbenefit = 0 --this value will be set based on items used. 
-- The higher the sampling benefit, the better chance at a super-item. These take the
-- form of things like unlockable recipes via item as in vanilla starbound, or super-seeds
-- and that sort of thing.


}

function init(args)
    self.timer = 0
    self.recipe = nil
    self.crafting = false
end

function hasValidRecipe()
    local id = entity.id()
    local contents = world.containerItems(entity.id())

    for _, recipe in pairs(recipes) do
        local hasRecipe = true
        for id, item in pairs(recipe.inputs) do
            local found = false
            for i, inv in pairs(contents) do
                if item == inv.name then
                    found = true
                    break -- Break the item search loop
                end
            end
           
            if not found then
                hasRecipe = false
                break -- Break loop for current recipe
            end
        end
       
        -- Do we have the match?
        if hasRecipe then
            return true, recipe
        end
    end
   
    return false, nil
end

-- Adds in/Removes the items. If you added the amount param to tables, be sure to update it here.
function generateRecipe()
    local recipe = self.recipe
    local entID = entity.id()
   
    -- Remove the input items
    for k, v in pairs(recipe.inputs) do
        if not world.containerConsume(entID, {item = v , count = 1}) then
            return 
        end
    end
   
    -- Add the output items
    for k, item in pairs(recipe.outputs) do
        local itemsRemaining = world.containerAddItems(entID, { name= item, count = 1, data={}})

        if itemsRemaining then
            world.spawnItem(itemsRemaining.item, entity.position(), itemsRemaining.amount)
        end
    end
end

function update(dt)
    -- Are we already crafting?
    if not self.crafting then
        -- No? Check recipes.
        local hasRecipe, recipe = hasValidRecipe()
        if hasRecipe then
            self.recipe = recipe
            entity.setAnimationState("samplingarrayanim", "working") 
            self.crafting = true
        end
    else
        -- Yes? Run timer.
        self.timer = self.timer + dt -- Make it work with actual SECONDS
        if self.timer >= self.recipe.time then
            generateRecipe() -- Take the recipe requirements and Generate the results
            self.crafting = false
            self.timer = 1
            entity.setAnimationState("samplingarrayanim", "idle")
        end
    end
end
