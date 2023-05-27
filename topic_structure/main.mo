import Level "Level";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor MQTT_Broker {
    type Level = Level.Level;
    type Topic = Level.Topic;

    var root : Level.Level = {
        name = "Root";
        superLevel = null;
        subLevel = Buffer.Buffer<Level>(0);
        topics = Buffer.Buffer<Topic>(0);
    };
    public func addTopic(fullPath : Text) : async () {
        var levels = Iter.toArray(Text.split(fullPath, #char '/')); //creamos un Array a partir del path
        let topic = levels[levels.size() -1]; //extraemos el nombre del topic
        levels := Array.subArray<Topic>(levels, 0, levels.size() -1); //eliminamos el nombre del topic
        var countLevel = 0;
        var currentLevel = root;
        for (l in levels.vals()) {
            let tempLevel = {
                name = l;
                superLevel = null;
                subLevel = Buffer.Buffer<Level>(0);
                topics = Buffer.Buffer<Topic>(0);
            };
            if (Buffer.contains<Level>(currentLevel.subLevel, tempLevel, Level.equal)) {
                //si el mivel ya existe se continuará subiendo de nivel
            } else {

                // Si el nivel no existe se creara dicho nivel dentro de currentLevel.subLevel con sus correspondiente
                // rama de Levels hasta el ultimo Level, el cual incluirá en su Buffer topics, el topic

            };

        };

    };

};
