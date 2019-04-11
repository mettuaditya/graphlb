module Dot
  Grammar = Pegmatite::DSL.define do
    comment_char = range(' ', 0x10FFFF_u32)
    comment = (char('#') >> (~char('\n') >> comment_char).maybe.repeat >> char('\n')).named(:comment, false)
    multi_comment_char = ~str("*/") >> (
      comment_char | char('\n') | char('\r') | char('\t')
      )
    multi_comment =(char('/') >> char('*') >>
      multi_comment_char.maybe.repeat >>
      char('*') >> char('/')
      ).named(:multi_comment, false)

    line_break = char('\r') | char('\n').named(:line_break, false)
    whitespace = (char(' ') | char('\t')).named(:whitespace, false)

    # Define what optional whitespace looks like.
    s = (multi_comment | comment | whitespace | line_break).repeat.named(:ignored, false)

    # Define what a number looks like.
    digit19 = range('1', '9')
    digit = range('0', '9')
    digits = digit.repeat(1)
    int = (char('-') >> digit19 >> digits) |
        (char('-') >> digit) |
        (digit19 >> digits) |
        digit
    frac = char('.') >> digits
    exp = (char('e') | char('E')) >> (char('+') | char('-')).maybe >> digits
    numeric = int >> frac.maybe >> exp.maybe
    numeric_str = char('"') >> numeric >> char('"')
    number = (numeric | numeric_str).named(:number)

    # Define what a string looks like.
    #hex = digit | range('a', 'f') | range('A', 'F')

    string_char =
        str("\\\"") | str("\\\\") | str("\\|") |
        str("\\b") | str("\\f") | str("\\n") | str("\\r") | str("\\t") |
        (~char('"') >> ~char('\\') >> range(' ', 0x10FFFF_u32))
    string = char('"') >> string_char.repeat.named(:string) >> char('"')

    identifier = ((range('a', 'z') | range('A', 'Z') | char('_')) >>
        (range('a', 'z') | range('A', 'Z') | digits | char('_') | char('-') | char('.')).repeat
        ).named(:identifier)

        t_null = str("null").named(:null)
        t_true = (str("true") | str("\"true\"")).named(:true)
        t_false = (str("false") | str("\"false\"")).named(:false)
        bool = t_true | t_false

        # Define what constitutes a value.
        value = t_null | bool | number | identifier | string

        # Define what an object is, in terms of zero or more key/value pairs.
        pair = (identifier >> s >> char('=') >> s  >> value).named(:assignment)
        pair_id = (identifier >> s >> char('=') >> s >> identifier)

        # block_item = pair | block
        # block_item_list = block_item >> s >> (block_item >> s).repeat
        #
        # # If we've got both blocks and key-value pairs, it's a block body
        # block_body = (char('{') >> s >> block_item_list.maybe >> s >> char('}')
        # ).named(:block_body)
        # block_args = (string >> s).maybe.repeat.named(:block_args)
        # block.define \
        # (identifier >> s >> block_args >> block_body).named(:block)
        # blocks = block >> s >> block.repeat

        subgraph = str("graph") | str("digraph")
        a_list = pair_id >> char(',') >> (pair_id >> char(',')).maybe.repeat| pair >> char(',') >> (pair >> char(',')).maybe.repeat  | pair_id | pair
        attr_list = char('[') >> a_list.maybe.repeat >> char(']')
        node_statement = (identifier >> s >> char('[') >> attr_list >> char(']')) | identifier
        edgeop = char('-') >> (char('>')| char('-'))
        edgeRHS = edgeop >> s.maybe >> identifier >> ( s >> edgeop >> s.maybe >> identifier).repeat | edgeop >> s >> identifier
        edge_statement = identifier >> s >> edgeRHS >> s >> char('[') >> attr_list >> char(']') | identifier >> s >> edgeRHS
        attr_statement = identifier >> s >> attr_list
        statement = s.maybe.repeat >> node_statement| s.maybe.repeat >> edge_statement | s.maybe.repeat >> attr_statement | s.maybe.repeat >> pair_id
        statement_list = statement >> char(';') >> s.maybe >> (statement >> char(';') >> s.maybe).maybe.repeat  | statement >> char(';') >> s.maybe
        graph = subgraph >> s >> identifier >> s.maybe >> char('{') >> s.maybe.repeat >> statement_list >> char('}').named(:block)

        # An HCL document is an list or object with optional surrounding whitespace.
        (s >> graph >> s).then_eof
    end
end
