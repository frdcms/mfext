CRONTAB_TARGET=$(MFMODULE_HOME)/config/crontab
LOGROTATE_TARGET=$(MFMODULE_HOME)/config/logrotate.conf

all:: $(MFMODULE_HOME)/config/version $(CRONTAB_TARGET) $(LOGROTATE_TARGET)

$(MFMODULE_HOME)/config/telegraf.conf: $(wildcard telegraf.conf.custom) $(MFEXT_HOME)/share/templates/telegraf.conf
	@mkdir -p $(MFMODULE_HOME)/config
	_make_file_from_template.sh telegraf.conf .custom >$@ || { rm -f $@ ; false ; }

$(MFMODULE_HOME)/config/circus.ini: $(wildcard circus.ini.custom) $(MFEXT_HOME)/share/templates/circus.ini
	@mkdir -p $(MFMODULE_HOME)/config
	_make_file_from_template.sh circus.ini .custom >$@ || { rm -f $@ ; false ; }

$(MFMODULE_HOME)/config/crontab: $(wildcard crontab.custom) $(MFEXT_HOME)/share/templates/crontab
	@mkdir -p $(MFMODULE_HOME)/config
	$(MFEXT_HOME)/bin/_make_file_from_template.sh crontab .custom >$@ || { rm -f $@ ; false ;}

$(MFMODULE_HOME)/config/logrotate.conf: $(wildcard logrotate.conf.custom) $(MFEXT_HOME)/share/templates/logrotate.conf
	@mkdir -p $(MFMODULE_HOME)/config
	$(MFEXT_HOME)/bin/_make_file_from_template.sh logrotate.conf .custom >$@ || { rm -f $@ ; false ;}

$(MFMODULE_HOME)/config/config.ini: $(wildcard config.ini*) $(MFEXT_HOME)/share/templates/config.ini
	@mkdir -p $(MFMODULE_HOME)/config
	if test -f config.ini.custom; then $(MFEXT_HOME)/bin/_make_file_from_template.sh config.ini .custom DONT_REDUCE >$@ || { rm -f $@ ; false ;}; else cp -f config.ini $@; fi
