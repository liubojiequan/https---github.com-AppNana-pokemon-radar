// Generated by the Protocol Buffers 3.0 compiler.  DO NOT EDIT!
// Source file "empty.proto"
// Syntax "Proto3"

import Foundation

public extension Google.Protobuf{}

public func == (lhs: Google.Protobuf.Empty, rhs: Google.Protobuf.Empty) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Google.Protobuf {
  public struct EmptyRoot {
    public static var sharedInstance : EmptyRoot {
     struct Static {
         static let instance : EmptyRoot = EmptyRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Google.Protobuf.SwiftDescriptorRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  // A generic empty message that you can re-use to avoid defining duplicated
  // empty messages in your APIs. A typical example is to use it as the request
  // or the response type of an API method. For instance:
  //     service Foo {
  //       rpc Bar(google.protobuf.Empty) returns (google.protobuf.Empty);
  //     }
  final public class Empty : GeneratedMessage, GeneratedMessageProtocol {
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Google.Protobuf.Empty> {
      var mergedArray = Array<Google.Protobuf.Empty>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Google.Protobuf.Empty? {
      return try Google.Protobuf.Empty.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromData(data, extensionRegistry:Google.Protobuf.EmptyRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Google.Protobuf.Empty.Builder {
      return Google.Protobuf.Empty.classBuilder() as! Google.Protobuf.Empty.Builder
    }
    public func getBuilder() -> Google.Protobuf.Empty.Builder {
      return classBuilder() as! Google.Protobuf.Empty.Builder
    }
    override public class func classBuilder() -> MessageBuilder {
      return Google.Protobuf.Empty.Builder()
    }
    override public func classBuilder() -> MessageBuilder {
      return Google.Protobuf.Empty.Builder()
    }
    public func toBuilder() throws -> Google.Protobuf.Empty.Builder {
      return try Google.Protobuf.Empty.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Google.Protobuf.Empty) throws -> Google.Protobuf.Empty.Builder {
      return try Google.Protobuf.Empty.Builder().mergeFrom(prototype)
    }
    override public func encode() throws -> Dictionary<String,AnyObject> {
      guard isInitialized() else {
        throw ProtocolBuffersError.InvalidProtocolBuffer("Uninitialized Message")
      }

      let jsonMap:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
      return jsonMap
    }
    override class public func decode(jsonMap:Dictionary<String,AnyObject>) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder.decodeToBuilder(jsonMap).build()
    }
    override class public func fromJSON(data:NSData) throws -> Google.Protobuf.Empty {
      return try Google.Protobuf.Empty.Builder.fromJSONToBuilder(data).build()
    }
    override public func getDescription(indent:String) throws -> String {
      var output = ""
      output += unknownFields.getDescription(indent)
      return output
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Google.Protobuf.Empty"
    }
    override public func className() -> String {
        return "Google.Protobuf.Empty"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Google.Protobuf.Empty.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Google.Protobuf.Empty = Google.Protobuf.Empty()
      public func getMessage() -> Google.Protobuf.Empty {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      override public func clear() -> Google.Protobuf.Empty.Builder {
        builderResult = Google.Protobuf.Empty()
        return self
      }
      override public func clone() throws -> Google.Protobuf.Empty.Builder {
        return try Google.Protobuf.Empty.builderWithPrototype(builderResult)
      }
      override public func build() throws -> Google.Protobuf.Empty {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Google.Protobuf.Empty {
        let returnMe:Google.Protobuf.Empty = builderResult
        return returnMe
      }
      public func mergeFrom(other:Google.Protobuf.Empty) throws -> Google.Protobuf.Empty.Builder {
        if other == Google.Protobuf.Empty() {
         return self
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      override public func mergeFromCodedInputStream(input:CodedInputStream) throws -> Google.Protobuf.Empty.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      override public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.Empty.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let protobufTag = try input.readTag()
          switch protobufTag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          default:
            if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:protobufTag))) {
               unknownFields = try unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
      override class public func decodeToBuilder(jsonMap:Dictionary<String,AnyObject>) throws -> Google.Protobuf.Empty.Builder {
        let resultDecodedBuilder = Google.Protobuf.Empty.Builder()
        return resultDecodedBuilder
      }
      override class public func fromJSONToBuilder(data:NSData) throws -> Google.Protobuf.Empty.Builder {
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        guard let jsDataCast = jsonData as? Dictionary<String,AnyObject> else {
          throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid JSON data")
        }
        return try Google.Protobuf.Empty.Builder.decodeToBuilder(jsDataCast)
      }
    }

  }

}

// @@protoc_insertion_point(global_scope)
