require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase

  describe Institution do
    context 'creates an institution' do
      it 'with correct name' do
        institution = Institution.create(name: 'Stanford University')
        institution.name = 'Stanford University '
      end
    end
  end
 end
