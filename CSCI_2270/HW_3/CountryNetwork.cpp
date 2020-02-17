/****************************************************************/
/*                CountryNetwork Implementation                 */
/****************************************************************/
/* TODO: Implement the member functions of class CountryNetwork */
/*     This class uses a linked-list of Country structs to      */
/*     represet communication paths between nations             */
/****************************************************************/

#include "CountryNetwork.hpp"

using namespace std;

/*
 * Purpose: Constructer for empty linked list
 * @param none
 * @return none
 */
CountryNetwork::CountryNetwork()
{
    // TODO
    head = NULL;
}


/*
 * Purpose: Add a new Country to the network
 *   between the Country *previous and the Country that follows it in the network.
 * @param previous name of the Country that comes before the new Country
 * @param countryName name of the new Country
 * @return none
 */
void CountryNetwork::insertCountry(Country* previous, string countryName)
{
    // TODO
    Country *node = new Country;
    node->name = countryName;
    if ((previous == NULL)||(head == NULL)) {
      std::cout << "adding: "<< countryName << " (HEAD)" << '\n';
      node->next = head;
      head = node;
    } else {
      std::cout << "adding: "<< countryName << " (prev: " << previous->name << ")" << '\n';
      node->next = previous->next;
      previous->next = node;
    }


}

/*
 * Purpose: populates the network with the predetermined countries
 * @param none
 * @return none
 adding: United States (HEAD)
adding: Canada (prev: United States)
adding: Brazil (prev: Canada)
adding: India (prev: Brazil)
adding: China (prev: India)
adding: Australia (prev: China)
 */
void CountryNetwork::loadDefaultSetup()
{
    // TODO
    Country *temp;
    head = NULL;
    insertCountry(head, "United States");
    temp = searchNetwork("United States");
    insertCountry(temp, "Canada");
    temp = searchNetwork("Canada");
    insertCountry(temp, "Brazil");
    temp = searchNetwork("Brazil");
    insertCountry(temp, "India");
    temp = searchNetwork("India");
    insertCountry(temp, "China");
    temp = searchNetwork("China");
    insertCountry(temp, "Australia");
}

/*
 * Purpose: Search the network for the specified country and return a pointer to that node
 * @param countryName name of the country to look for in network
 * @return pointer to node of countryName, or NULL if not found
 */
Country* CountryNetwork::searchNetwork(string countryName)
{
    // TODO
    Country *ptr = head;
    while ((ptr != NULL)&&(ptr->name != countryName)) {
      ptr = ptr->next;
    }
    return ptr;
}

/*
 * Purpose: Transmit a message across the network to the
 *   receiver. Msg should be stored in each country it arrives
 *   at, and should increment that country's count.
 * @param receiver name of the country to receive the message
 * @param message the message to send to the receiver
 * @return none
 */
void CountryNetwork::transmitMsg(string receiver, string message)
{
    // TODO
    Country *temp = head;
    while (temp->name != receiver) {
      temp->numberMessages++;
      temp->message = message;
      //United States [# messages received: 1] received: bom Dia
      std::cout << temp->name << " [# messages received: " << temp->numberMessages << "] received: " << message << '\n';
      temp = temp->next;
    }
    temp->numberMessages++;
    temp->message = message;
          std::cout << temp->name << " [# messages received: " << temp->numberMessages << "] received: " << message << '\n';
}

/*
 * Purpose: prints the current list nicely
 * @param ptr head of list
 */
void CountryNetwork::printPath()
{
    // TODO
    //United States -> Canada -> Brazil -> India -> China -> Australia -> NULL
    Country *temp = head;
    std::cout << "== CURRENT PATH ==" << '\n';
    if (head == NULL) {
      std::cout << "nothing in path" << '\n';
    }else{
      while (temp != NULL) {
        std::cout<< temp->name << " -> ";
        temp = temp->next;
      }
      std::cout << "NULL" << '\n';
    }

    std::cout << "===" << '\n';
}
