// import React, { useState, useEffect, useCallback, useRef } from "react";
// import { GetHttp } from "../../services/https/GetHttp";
// import { PostHttp } from "../../services/https/PostHttp";
// import { formatDate } from "../../utils/formatDate";
// import toast from "react-hot-toast";
// import Table from "@mui/material/Table";
// import TableBody from "@mui/material/TableBody";
// import TableCell from "@mui/material/TableCell";
// import TableContainer from "@mui/material/TableContainer";
// import TableHead from "@mui/material/TableHead";
// import TableRow from "@mui/material/TableRow";

// interface ICustomerData {
//   id: string;
//   name: string;
//   email: string;
//   phone: string;
//   dateAdded: string;
// }

// const CustomerSection: React.FC = () => {
//   const [customers, setCustomers] = useState<ICustomerData[]>([]);
//   const [loading, setLoading] = useState(true);
//   const [searchInput, setSearchInput] = useState("");
//   const [filteredCustomers, setFilteredCustomers] = useState<ICustomerData[]>([]);
//   const [showNewCustomerForm, setShowNewCustomerForm] = useState(false);

//   const newCustomerFormRef = useRef<HTMLFormElement>(null);

//   // ✅ Get business_id from sessionStorage
//   const getSessionData = () => {
//     const sessionData = window.sessionStorage.getItem("data");
//     if (sessionData) {
//       const parsed = JSON.parse(sessionData);
//       return { businessId: parsed.business_id || "" };
//     }
//     return { businessId: "" };
//   };
//   const sessionDefaults = getSessionData();

//   // ✅ Fetch customers
//   const fetchCustomers = useCallback(async () => {
//     setLoading(true);
//     try {
//       const response = await GetHttp({
//         pathname: "/customer/fetchAll",
//         payload: { business_id: sessionDefaults.businessId },
//         isProtected: true,
//       });

//       if (response?.success === true || response?.data) {
//         const customerList = response.data || response.customers || [];
//         const formattedCustomers: ICustomerData[] = customerList.map(
//           (customer: any, index: number) => ({
//             id: customer._id || customer.customer_id || `customer-${index}`,
//             name:
//               customer.customer_name ||
//               `${customer.firstName || ""} ${customer.lastName || ""}`.trim() ||
//               "N/A",
//             email: customer.customer_email || customer.email || "N/A",
//             phone: customer.customer_phonenumber || customer.phone || "N/A",
//             dateAdded: formatDate(
//               customer.createdAt || customer.date_added || new Date().toISOString()
//             ),
//           })
//         );

//         setCustomers(formattedCustomers);
//         setFilteredCustomers(formattedCustomers);
//       } else {
//         setCustomers([]);
//         setFilteredCustomers([]);
//         toast.error("Failed to load customers: No data received");
//       }
//     } catch (error) {
//       console.error("Error fetching customers:", error);
//       toast.error("Failed to fetch customers");
//     } finally {
//       setLoading(false);
//     }
//   }, [sessionDefaults.businessId]);

//   useEffect(() => {
//     if (sessionDefaults.businessId) {
//       fetchCustomers();
//     } else {
//       setLoading(false);
//       toast.error("No business ID found in session");
//     }
//   }, [sessionDefaults.businessId, fetchCustomers]);

//   // ✅ Create new customer
//   const createNewCustomer = async () => {
//     const form = newCustomerFormRef.current;
//     if (!form) return;

//     const formData = new FormData(form);
//     const customerData = {
//       customer_name: (formData.get("customer_name") as string) || "",
//       customer_email: (formData.get("customer_email") as string) || "",
//       customer_phonenumber: (formData.get("customer_phonenumber") as string) || "",
//       customer_address: (formData.get("customer_address") as string) || "",
//     };

//     if (!customerData.customer_name.trim()) {
//       toast.error("Customer name is required");
//       return;
//     }
//     if (!customerData.customer_email.trim()) {
//       toast.error("Customer email is required");
//       return;
//     }

//     try {
//       const response = await PostHttp({
//         pathname: "/customer/create",
//         payload: { ...customerData, business_id: sessionDefaults.businessId },
//         formType: "json",
//       });

//       if (response?.success === true) {
//         toast.success("Customer created successfully");
//         form.reset();
//         setShowNewCustomerForm(false);
//         fetchCustomers(); // ✅ Refresh list
//       } else {
//         toast.error(`Failed: ${response?.message || "Error creating customer"}`);
//       }
//     } catch (error) {
//       toast.error("Error creating customer");
//     }
//   };

//   const handleSearchInput = (event: React.ChangeEvent<HTMLInputElement>) => {
//     const { value } = event.target;
//     setSearchInput(value);

//     if (value.length >= 3) {
//       const matchedResult = customers.filter(
//         (customer) =>
//           customer?.name?.toLowerCase()?.includes(value?.toLowerCase()) ||
//           customer?.email?.toLowerCase()?.includes(value?.toLowerCase()) ||
//           customer?.phone?.toLowerCase()?.includes(value?.toLowerCase())
//       );
//       setFilteredCustomers(matchedResult);
//     } else {
//       setFilteredCustomers(customers);
//     }
//   };

//   const getInitials = (name: string) => {
//     if (!name) return "CU";
//     const parts = name.split(" ");
//     if (parts.length >= 2) {
//       return `${parts[0]?.charAt(0) || ""}${parts[1]?.charAt(0) || ""}`;
//     }
//     return name.charAt(0) || "C";
//   };

//   return (
//     <div className="mt-10">
//       <div className="flex items-center justify-between mb-4">
//         <h2 className="text-xl font-bold text-gray-800">Customers</h2>
//         <button
//           onClick={() => setShowNewCustomerForm(!showNewCustomerForm)}
//           className="px-4 py-2 text-sm font-medium text-white bg-yellow-600 rounded-lg hover:bg-yellow-700"
//         >
//           {showNewCustomerForm ? "Cancel" : "New Customer"}
//         </button>
//       </div>

//       {/*  New Customer Form */}
//       {showNewCustomerForm && (
//         <form
//           ref={newCustomerFormRef}
//           className="p-4 mb-6 border rounded-lg bg-gray-50 space-y-3"
//         >
//           <input
//             name="customer_name"
//             placeholder="Customer Name"
//             className="w-full px-3 py-2 border rounded"
//             required
//           />
//           <input
//             name="customer_email"
//             placeholder="Customer Email"
//             className="w-full px-3 py-2 border rounded"
//             required
//           />
//           <input
//             name="customer_phonenumber"
//             placeholder="Phone Number"
//             className="w-full px-3 py-2 border rounded"
//           />
//           <input
//             name="customer_address"
//             placeholder="Address"
//             className="w-full px-3 py-2 border rounded"
//           />
//           <button
//             type="button"
//             onClick={createNewCustomer}
//             className="px-4 py-2 text-sm font-medium text-white bg-green-600 rounded hover:bg-green-700"
//           >
//             Save Customer
//           </button>
//         </form>
//       )}

//       {/* ✅ Search bar */}
//       <div className="w-full max-w-md mb-4">
//         <input
//           type="text"
//           placeholder="Search customers..."
//           value={searchInput}
//           onChange={handleSearchInput}
//           className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-yellow-500 text-sm"
//         />
//       </div>

//       {/* ✅ Customer table */}
//       {loading ? (
//         <div className="flex items-center justify-center w-full h-32">
//           <p className="text-sm text-gray-600 animate-pulse">Fetching customers...</p>
//         </div>
//       ) : !filteredCustomers?.length ? (
//         <div className="flex items-center justify-center w-full h-32">
//           <p className="text-xl font-semibold text-gray-600">
//             {searchInput ? "No matching customers found!" : "No customers found!"}
//           </p>
//         </div>
//       ) : (
//         <TableContainer className="max-h-[600px] overflow-y-auto">
//           <Table stickyHeader>
//             <TableHead>
//               <TableRow>
//                 <TableCell>Date Added</TableCell>
//                 <TableCell>Customer</TableCell>
//                 <TableCell>Email</TableCell>
//                 <TableCell>Phone</TableCell>
//                 <TableCell>Actions</TableCell>
//               </TableRow>
//             </TableHead>
//             <TableBody>
//               {filteredCustomers.map((customer) => (
//                 <TableRow key={customer.id}>
//                   <TableCell>{customer.dateAdded}</TableCell>
//                   <TableCell>{customer.name}</TableCell>
//                   <TableCell>{customer.email}</TableCell>
//                   <TableCell>{customer.phone}</TableCell>
//                   <TableCell>
//                     <button className="text-yellow-600 hover:text-yellow-700 text-sm font-medium">
//                       View
//                     </button>
//                   </TableCell>
//                 </TableRow>
//               ))}
//             </TableBody>
//           </Table>
//         </TableContainer>
//       )}
//     </div>
//   );
// };

// export default CustomerSection;

