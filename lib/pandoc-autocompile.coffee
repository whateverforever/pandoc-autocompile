PandocAutocompileView   = require './pandoc-autocompile-view'
{CompositeDisposable} = require 'atom'

module.exports = PandocAutocompile =
  pandocAutocompileView: null

  config:
      fileTypes:
          type: 'array'
          default: ['.md','.markdown']
      outputDirectory:
          type: 'string'
          description: 'Directory for output. Relative to project path.'
          default: '.'
      outputFileFormat:
          type: 'string'
          description: 'What file to convert to'
          default: '.docx'
      pandocPath:
          type: 'string'
          default: 'pandoc'

  activate: (state) ->
    @pandocAutocompileView = new PandocAutocompileView(state.pandocAutocompileViewState)

  deactivate: ->
    @pandocAutocompileView.destroy()

  serialize: ->
    pandocAutocompileViewState: @pandocAutocompileView.serialize()
