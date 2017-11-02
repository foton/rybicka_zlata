# frozen_string_literal: true

{ en: {
  activerecord: {
    models: {
      group: {
        one: 'Group',
        other: 'Groups'
      }
    },
    attributes: {
      group: {
        name: 'Name'
      }
    },
    errors: {
      models: {
        group: {
          attributes: {
            name: {
              too_short: 'This Name is too short'
            }
          }
        }
      }
    }

  },

  groups: {
    actions: {
      new: {
        button: 'Add',
        next_button: 'Next'
      },
      save: {
        button: 'Save'
      },
      edit: {
        button: 'Edit'
      },
      delete: {
        button: 'Delete',
        confirm: {
          message: "Do You really want to delete the '%{object_title}' group?"
        }
      }
    },
    views: {
      header: 'Groups',
      help: 'Groups are usefull when You edit the wish. They allows You to move more connections at once. And they are optional.',
      add: {
        name: 'Name of group'
      },
      added: "Group '%{name}' was successfully added. Fill it with friends, please.",
      not_added: "Group '%{name}' was not added.",
      updated: "Group '%{name}' was successfully updated.",
      not_updated: "Group '%{name}' was not updated.",
      deleted: "Group '%{name}' was successfully deleted.",
      not_deleted: "Group '%{name}' was not deleted.",
      list: {
        header: 'Group list',
        none: 'No group yet'
      },
      delete: {
        confirm: {
          message: 'Really delete?'
        }
      }
    }
  }
} }
