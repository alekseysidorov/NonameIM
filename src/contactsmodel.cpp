#include "contactsmodel.h"
#include <buddy.h>

ContactsModel::ContactsModel(QObject *parent) :
    QAbstractListModel(parent),
    m_showGroups(false)
{
    auto roles = roleNames();
    roles[ContactRole] = "contact";
    roles[PhotoRole] = "photo";
    setRoleNames(roles);
}

void ContactsModel::setRoster(vk::Roster *roster)
{
    if (!m_roster.isNull())
        m_roster.data()->disconnect(this);
    m_roster = roster;

    foreach (auto contact, roster->contacts())
        addContact(contact);


    connect(roster, SIGNAL(contactAdded(vk::Contact*)), SLOT(addContact(vk::Contact*)));
    connect(roster, SIGNAL(contactRemoved(vk::Contact*)), SLOT(removeContact(vk::Contact*)));

    emit rosterChanged(roster);
}

vk::Roster *ContactsModel::roster() const
{
    return m_roster.data();
}

int ContactsModel::count() const
{
    return m_contactList.count();
}

QVariant ContactsModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    switch (role) {
    case ContactRole: {
        auto contact = m_contactList.at(row);
        return qVariantFromValue(contact);
        break;
    }
    case PhotoRole: {
        auto contact = m_contactList.at(row);
        return contact->photoSource(vk::Contact::PhotoSizeBig);
    } default:
        break;
    }
    return QVariant();
}

int ContactsModel::rowCount(const QModelIndex &parent) const
{
    return count();
}

void ContactsModel::setFilterByName(const QString &filter)
{
    m_filterByName = filter;
    emit filterByNameChanged(filter);

    //TODO write more fast algorythm
    clear();
    foreach (auto contact, m_roster.data()->contacts())
        addContact(contact);
}

QString ContactsModel::filterByName()
{
    return m_filterByName;
}

void ContactsModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, m_contactList.count());
    m_contactList.clear();
    endRemoveRows();
}

void ContactsModel::addContact(vk::Contact *contact)
{
    if (!checkContact(contact))
        return;
    int index = m_contactList.count();
    beginInsertRows(QModelIndex(), index, index);
    m_contactList.append(contact);
    endInsertRows();
}

void ContactsModel::removeContact(vk::Contact *contact)
{
    int index = m_contactList.indexOf(contact);
    if (index == -1)
        return;
    beginRemoveRows(QModelIndex(), index, index);
    m_contactList.removeAt(index);
    endRemoveRows();
}

bool ContactsModel::checkContact(vk::Contact *contact)
{
    if (vk::contact_cast<vk::Group*>(contact))
        return false;
    if (!m_filterByName.isEmpty())
        return contact->name().contains(m_filterByName, Qt::CaseInsensitive);
    return true;
}
