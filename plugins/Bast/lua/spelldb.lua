require 'tprint'
require 'verify'
require 'pluginhelper'
require 'sqlitedb'
require 'aardutils'
require 'tablefuncs'

SpellDB = Sqlitedb:subclass()

function donothing(args)

end

function SpellDB:initialize(args)
	super(self, args)
	self.dbname = "\\spells.db"
	self.version = 0
	
	self:addtable('class', [[CREATE TABLE class(
		class_serial INTEGER NOT NULL PRIMARY KEY autoincrement,
		class_name TEXT NOT NULL,
		UNIQUE(class_name)
	)]], nil, nil, 'class_serial')
	
	self:addtable('subClass', [[CREATE TABLE subClass(
		subClass_serial INTEGER NOT NULL PRIMARY KEY autoincrement,
		subClass_name TEXT NOT NULL,
		class_serial INTEGER NOT NULL,
		UNIQUE(subClass_name),
		FOREIGN KEY(class_serial) REFERENCES class(class_serial)
	)]], nil, nil, 'subClass_serial')
	
	self:addtable('spell', [[CREATE TABLE spell(
		spell_serial INTEGER NOT NULL,
		spell_name TEXT NOT NULL,
		PRIMARY KEY(spell_serial, spell_name)
	)]], nil, nil, 'spell_serial')
	
	self:postinit()
end --SpellDB:initialize

function SpellDB:turnonpragmas()
  -- PRAGMA foreign_keys = ON;
  self.db:exec("PRAGMA foreign_keys=1;")
  -- PRAGMA journal_mode=WAL
  self.db:exec("PRAGMA journal_mode=WAL;")
end

function SpellDB:add_class(className, counter)
  if self:open('add_class') then
	Note("SpellDB:add_class :: " .. string.format('INSERT INTO class (class_serial, class_name) VALUES (%s, %s)', counter, className))
    local err = self.db:exec(string.format('INSERT INTO class (class_serial, class_name) VALUES (%s, "%s")', counter, className))
	Note("\r\nself.db:exec return :: " .. err)
    self:close('add_class')
  end
  return false
end