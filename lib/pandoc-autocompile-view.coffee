path     = require 'path'
childprocess = require 'child_process'
exec = childprocess.exec

module.exports =
class PandocAutocompileView
  constructor: (serializeState) ->
    atom.commands.add 'atom-workspace', 'core:save': => @handleSave()
    atom.config.onDidChange 'pandoc-autocompile', ({newValue, oldValue}) =>
        @setGlobals()
    @setGlobals()

  serialize: ->

  destroy: ->

  setGlobals: ->
      @fileTypes = atom.config.get('pandoc-autocompile.fileTypes')
      @outputDirectory = atom.config.get('pandoc-autocompile.outputDirectory')
      @outputFileFormat = atom.config.get('pandoc-autocompile.outputFileFormat')
      @pandocPath = atom.config.get('pandoc-autocompile.pandocPath')

  handleSave: ->
    @activeEditor = atom.workspace.getActiveTextEditor()
    @projectPath = atom.project.getDirectories()[0].path

    if @activeEditor
      @filePath = @activeEditor.getURI()
      @fileExt = path.extname @filePath

      if @fileExt in @fileTypes
          @callPandoc()

  callPandoc: ->
      directory = path.normalize @projectPath + '/' + @outputDirectory

      filename = path.basename @filePath
      targetFile = path.join directory, filename + @outputFileFormat

      child = exec @pandocPath + ' "'+@filePath+'" -o "'+targetFile+'"'

      child.stderr.on 'data', (data) =>
          console.error 'error ' + data
          atom.notifications.addError data
      child.on 'close', (code) =>
          if code is 0
              atom.notifications.addSuccess 'Converted Successfully :)'
