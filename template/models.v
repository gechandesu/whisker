module template

import os
import datamodel { DataModel }

pub struct Template {
pub:
	tokens   []Token
	partials map[string][]Token
}

[params]
pub struct TemplateConfig {
	input    string            [required]
	partials map[string]string = {}
}

pub fn from_strings(config TemplateConfig) !Template {
	if config.input.len == 0 {
		return Template{}
	}

	mut tokenized_partials := map[string][]Token{}

	for label, partial in config.partials {
		tokenized_partials[label] = tokenize(partial)!
	}

	return Template{
		tokens: tokenize(config.input)!
		partials: tokenized_partials
	}
}

struct Section {
	name     string
	contexts []DataModel
}

pub fn load_file(config TemplateConfig) !Template {
	input := os.read_file(config.input)!

	mut partial_contents := map[string]string{}
	for partial_name, path in config.partials {
		partial_contents[partial_name] = os.read_file(path)!
	}

	return from_strings(input: input, partials: partial_contents)
}