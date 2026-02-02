#include "PatientNameViewModel.h"

#include <drive/common/PatientName.h>
#include <drive/com/propertysource/PatientDetailsPropertySource.h>
#include <drive/com/propertysource/PatientsPropertySource.h>


namespace drive::viewmodel {

PatientNameViewModel::PatientNameViewModel(QObject* parent)
    : QObject(parent)
    , m_patientDetailsPS(
          std::make_unique<com::propertysource::PatientDetailsPropertySource>(
              parent))
    , m_patientsPS(
          std::make_unique<com::propertysource::PatientsPropertySource>(parent))
{
    connect(
        m_patientDetailsPS.get(),
        &com::propertysource::PatientDetailsPropertySource::patientNameChanged,
        this, &PatientNameViewModel::onPatientNameChanged);
    onPatientNameChanged(m_patientDetailsPS->patientName());

    connect(m_patientsPS.get(),
            &com::propertysource::PatientsPropertySource::
                selectedPatientIdStrChanged,
            this, &PatientNameViewModel::onSelectedPatientIdStrChanged);
    onSelectedPatientIdStrChanged(m_patientsPS->selectedPatientIdStr());
}

void PatientNameViewModel::onPatientNameChanged(const QString& patientName)
{
    auto formattedName =
        drive::common::PatientName::fromDicomFullName(patientName)
            .toAbbreviated();

    if (m_patientName != formattedName)
    {
        m_patientName = formattedName;
        emit patientNameChanged(m_patientName);
    }
}

void PatientNameViewModel::onSelectedPatientIdStrChanged(
    const QString& patientIdStr)
{
    auto patientSelected = false;
    if (!patientIdStr.isEmpty())
    {
        patientSelected = true;
    }

    if (m_patientSelected != patientSelected)
    {
        m_patientSelected = patientSelected;
        emit patientSelectedChanged(m_patientSelected);
    }
}

}  // namespace drive::viewmodel
