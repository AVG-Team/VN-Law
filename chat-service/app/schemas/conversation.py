from marshmallow import fields, Schema

class ConversationSchema(Schema):
    id = fields.Int(dump_only=True)
    user_id = fields.Int(required=True)
    message = fields.Str(required=True, validate=fields.Length(min=1))
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)
    context = fields.Str(required=True, validate=fields.Length(min=1))
    