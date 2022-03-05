
(string) @String
(comment) @Comment

(function_definition "def" @Def)
(function_definition name: (_) @DefName)
(function_definition return_type: (type) @DefReturnType (set! "priority" 200))
(function_definition parameters: (parameters (identifier) @DefParameter))
(function_definition parameters: (parameters (typed_parameter (identifier) @DefParameter)))
(function_definition parameters: (parameters (typed_parameter type: (_) @DefParameterType (set! "priority" 200))))
(function_definition parameters: (parameters (default_parameter name: (identifier) @DefParameter)))
(function_definition parameters: (parameters (default_parameter value: (_) @DefParameterValue (set! "priority" 200))))
(function_definition parameters: (parameters (typed_default_parameter name: (identifier) @DefParameter)))
(function_definition parameters: (parameters (typed_default_parameter type: (_) @DefParameterType (set! "priority" 200))))
(function_definition parameters: (parameters (typed_default_parameter value: (_) @DefParameterValue (set! "priority" 200))))
(function_definition body: (block . (expression_statement (string) @DefDocString)))
(block (return_statement "return" @DefReturn))
(decorated_definition (decorator) @Decorator (set! "priority" 200))

;(class_definition body: (block (function_definition parameters: (parameters . (identifier) @Self))))

(call function: _ @CallTarget (set! "priority" 150))
(call arguments: (argument_list "(" @CallParenthesis))
(call arguments: (argument_list "," @CallComma))
(call arguments: (argument_list ")" @CallParenthesis))
(call arguments: (argument_list (_ !name) @CallArgumentValue))
(call arguments: (argument_list (keyword_argument name: _ @CallArgumentName)))
(call arguments: (argument_list (keyword_argument "=" @CallArgumentEqual)))
(call arguments: (argument_list (keyword_argument value: _ @CallArgumentValue (set! "priority" 170))))

(assignment left: (_) @AssignmentLeft)
(augmented_assignment left: (_) @AssignmentLeft (set! "priority" 200))

(if_statement "if" @If ":" @If)
(if_statement alternative: (elif_clause "elif" @Elif ":" @Elif))
(if_statement alternative: (else_clause "else" @Else ":" @Elif))
