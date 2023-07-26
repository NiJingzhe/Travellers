extends DataSheet
# 物品栏目前的属性：物品栏容量， 物品列表 
# 以后可以按需添加若干比如视觉属性等

func _ready():
	self.init_sheet(["Capacity", "ItemList"])
	
	
