func! s:ensureAdded() " {{{
    " NOTE: requires: gem install xcode proj

    " if get(b:, '_swift_xcode_added', 0)
    "     return
    " endif

    let b:_swift_xcode_added = 1
    let proj = dhleong#ft#swift#FindProj()
    if proj ==# ''
        return
    endif

    let file = expand("%:p")
    let project = {'targets': []}
    func project.setTargets(targets) dict
        let self.targets = a:targets
    endfunc

ruby << EOF
    require 'xcodeproj'
    projectPath = Vim::evaluate('proj')
    filePath = Vim::evaluate('file')

    project = Xcodeproj::Project.open(projectPath)
    existing = project.targets.index do |target|
        nil != target.source_build_phase.files.to_a.index do |file|
            file.file_ref.real_path.to_s == filePath
        end
    end

    if existing.nil?
        targets = project.targets.map { |target| '"' + target.name + '"' }
            .join(',')

        Vim::evaluate('project.setTargets([' + targets + '])')
    end
EOF

    if len(project.targets)
        call s:promptAddToTarget(proj, file, project.targets)
    endif
endfunc " }}}

func! s:tryEnsureAdded()
    try
        call s:ensureAdded()
    catch /Could not load library/
        " ignore
    endtry
endfunc

func! s:promptAddToTarget(projectRoot, file, targets)
    " TODO other prompt methods?

    call fzf#run({
        \ 'source': a:targets,
        \ 'sink*': function('s:addFileToTargets', [a:projectRoot, a:file]),
        \ 'options': '--multi',
        \ })
endfunc

func! s:addFileToTargets(projectRoot, file, targets) " {{{
    " ref: https://stackoverflow.com/questions/44771181/ruby-script-xcodeproj-to-add-all-source-files-to-a-target

ruby << EOF
    require 'xcodeproj'
    projectPath = Vim::evaluate('a:projectRoot')
    filePath = Vim::evaluate('a:file')
    targets = Vim::evaluate('a:targets')

    project = Xcodeproj::Project.open(projectPath)

    def ensureGroup(project, dir)
        if dir.empty?
            raise "unable to find existing group"
        end

        # ensure intermediate groups exist:
        existing = project[dir]
        return existing unless existing.nil?

        parentGroup = ensureGroup(project, File.dirname(dir))
        return parentGroup.new_group(File.basename(dir))
    end

    # add the file to a "group" for the dir it's in
    fileDir = File.dirname(filePath)
    fileDirRelative = fileDir[project.project_dir.to_s.length+1..-1]
    group = ensureGroup(project, fileDirRelative)
    ref = group.new_file(filePath)

    project.targets.each do |target|
        next unless targets.include? target.name

        target.add_file_references([ref])
    end

    project.save
EOF

endfunc " }}}

func! dhleong#ft#swift#FindProj()
    let existing = get(b:, 'swift_xcode_project', '')
    if existing !=# ''
        return existing
    endif

    let project = fnamemodify(findfile('project.pbxproj'), ':p:h')
    if project !=# '' && project =~# '.xcodeproj$'
        let b:swift_xcode_project = project
        return b:swift_xcode_project
    endif

    return ''
endfunc

func! dhleong#ft#swift#init()
    augroup swift_xcode
        autocmd!
        autocmd BufWrite <buffer> call <SID>tryEnsureAdded()
        " TODO generate initial template?
    augroup END
endfunc
