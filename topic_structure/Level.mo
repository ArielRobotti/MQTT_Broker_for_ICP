import Buffer "mo:base/Buffer";
module {
    public type Topic = Text;
    public type Level = {name : Text; 
                        superLevel : ?Level; 
                        subLevel : Buffer.Buffer<Level>; 
                        topics : Buffer.Buffer<Topic>;
    };
    public func mkLevel(super : ?Level, name : Text) : async () {
        switch (super) {
            case (?level) {
                for (i in level.subLevel.vals()) {
                    if (i.name == name) {
                        //return i;
                        return ();
                    };
                };
                let newLevel: Level = {
                    name = name;
                    superLevel = super;
                    subLevel = Buffer.Buffer<Level>(0);
                    topics = Buffer.Buffer<Topic>(0)
                };
                level.subLevel.add(newLevel);
                return ();
                //return newLevel;
            };
            case (null) {
                let newLevel: Level = {
                    name = name;
                    superLevel = super;
                    subLevel = Buffer.Buffer<Level>(0);
                    topics = Buffer.Buffer<Topic>(0)
                };
                //return newLevel;
                return ();     
            };
        };
    };
    public func mkTopic(super: Level, t: Topic): async (){
        super.topics.add(t);
    };
    public func equal(a: Level , b: Level): Bool{
        return a.name == b.name;
    };

};
