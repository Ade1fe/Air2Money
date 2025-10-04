// import React, { useState, useEffect, useCallback } from "react";
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

// interface ISupplierData {
//   id: string;
//   name: string;
//   email: string;
//   phone: string;
//   dateAdded: string;
// }

// const SupplierSection: React.FC = () => {
//   const [suppliers, setSuppliers] = useState<ISupplierData[]>([]);
//   const [loading, setLoading] = useState(true);
//   const [searchInput, setSearchInput] = useState("");
//   const [filteredSuppliers, setFilteredSuppliers] = useState<ISupplierData[]>([]);
//   const [showNewSupplierForm, setShowNewSupplierForm] = useState(false);

//   // Get business_id from sessionStorage
//   const getSessionData = () => {
//     const sessionData = window.sessionStorage.getItem("data");
//     if (sessionData) {
//       const parsed = JSON.parse(sessionData);
//       return {
//         businessId: parsed.business_id || "",
//       };
//     }
//     return { businessId: "" };
//   };

//   const sessionDefaults = getSessionData();

//   const fetchSuppliers = useCallback(async () => {
//     setLoading(true);
//     try {
//       const response = await GetHttp({
//         pathname: "/customer/fetchAll",
//         payload: { business_id: sessionDefaults.businessId, isCustomer: false },
//         isProtected: true,
//       });

//       if (response?.success === true || response?.data) {
//         const supplierList = response.data || response.suppliers || [];
//         const formattedSuppliers: ISupplierData[] = supplierList.map(
//           (supplier: any, index: number) => ({
//             id: supplier._id || supplier.customer_id || `supplier-${index}`,
//             name:
//               supplier.supplier_name ||
//               supplier.name ||
//               `${supplier.firstName || ""} ${supplier.lastName || ""}`.trim() ||
//               "N/A",
//             email: supplier.supplier_email || supplier.email || "N/A",
//             phone: supplier.supplier_phonenumber || supplier.phone || "N/A",
//             dateAdded: formatDate(
//               supplier.createdAt || supplier.date_added || new Date().toISOString()
//             ),
//           })
//         );

//         setSuppliers(formattedSuppliers);
//         setFilteredSuppliers(formattedSuppliers);
//       } else {
//         setSuppliers([]);
//         setFilteredSuppliers([]);
//         toast.error("Failed to load suppliers: No data received");
//       }
//     } catch (error) {
//       console.error("Error fetching suppliers:", error);
//       toast.error("Failed to fetch suppliers");
//     } finally {
//       setLoading(false);
//     }
//   }, [sessionDefaults.businessId]);

//   // Create New Supplier
//   const createNewSupplier = async () => {
//     const form = document.querySelector('#newSupplierForm') as HTMLFormElement;
//     if (!form) return;

//     const formData = new FormData(form);
//     const supplierData = {
//       customer_name: formData.get('supplier_name') as string || "",
//       customer_email: formData.get('supplier_email') as string || "",
//       customer_phonenumber: formData.get('supplier_phonenumber') as string || "",
//       customer_address: formData.get('supplier_address') as string || "",
//     };

//     if (!supplierData.customer_name.trim()) {
//       toast.error("Supplier name is required");
//       return;
//     }
//     if (!supplierData.customer_email.trim()) {
//       toast.error("Supplier email is required");
//       return;
//     }

//     try {
//       const response = await PostHttp({
//         pathname: "/customer/create",
//         payload: {
//           ...supplierData,
//           customer_id: `SUPP${Math.floor(Math.random() * 1000000000)}`,
//           business_id: sessionDefaults.businessId,
//           isCustomer: false, // Mark as supplier
//         },
//         formType: "json",
//       });

//       if (response?.success === true) {
//         toast.success("Supplier created successfully");
//         await fetchSuppliers();
//         setShowNewSupplierForm(false);
//         form.reset();
//       } else {
//         toast.error("Failed: " + response?.message);
//       }
//     } catch (error) {
//       toast.error("Error creating supplier");
//       console.error("Error creating supplier:", error);
//     }
//   };

//   // Fetch suppliers on component mount
//   useEffect(() => {
//     if (sessionDefaults.businessId) {
//       fetchSuppliers();
//     } else {
//       setLoading(false);
//       toast.error("No business ID found in session");
//     }
//   }, [sessionDefaults.businessId, fetchSuppliers]);

//   const handleSearchInput = (event: React.ChangeEvent<HTMLInputElement>) => {
//     const { value } = event.target;
//     setSearchInput(value);

//     if (value.length >= 3) {
//       const matchedResult = suppliers.filter(
//         (supplier) =>
//           supplier?.name?.toLowerCase()?.includes(value?.toLowerCase()) ||
//           supplier?.email?.toLowerCase()?.includes(value?.toLowerCase()) ||
//           supplier?.phone?.toLowerCase()?.includes(value?.toLowerCase())
//       );
//       setFilteredSuppliers(matchedResult);
//     } else {
//       setFilteredSuppliers(suppliers);
//     }
//   };

//   const getInitials = (name: string) => {
//     if (!name) return "SU";
//     const parts = name.split(" ");
//     if (parts.length >= 2) {
//       return `${parts[0]?.charAt(0) || ""}${parts[1]?.charAt(0) || ""}`;
//     }
//     return name.charAt(0) || "S";
//   };

//   const inputStyle = "h-[64px] w-full input-radius pl-8 outline-none border border-[#D9D9D9] invalid:border-[#D9D9D9] valid:border-yellow-500 focus:border-yellow-500 bg-transparent focus:bg-[#FAFAFA] disabled:bg-[#FAFAFA] duration-300";
//   const labelStyle = "block py-2 text-sm font-semibold";

//   return (
//     <div className="mt-10">
//       <h2 className="mb-4 text-xl font-bold text-gray-800">Suppliers</h2>

//       {/* New Supplier Form */}
//       <div className="mb-6">
//         <button
//           type="button"
//           onClick={() => setShowNewSupplierForm(!showNewSupplierForm)}
//           className="mb-4 px-4 py-2 text-sm font-semibold text-white bg-primary rounded-md hover:bg-opacity-90"
//         >
//           {showNewSupplierForm ? "Cancel" : "Add New Supplier"}
//         </button>

//         {showNewSupplierForm && (
//           <div className="p-4 mb-4 border border-gray-200 rounded-md bg-gray-50">
//             <h4 className="mb-3 font-semibold text-md text-gray-800">Add New Supplier</h4>
//             <form id="newSupplierForm">
//               <div className="flex items-center justify-between gap-4 mb-4">
//                 <div className="w-[47%]">
//                   <input
//                     type="text"
//                     name="supplier_name"
//                     placeholder="Enter supplier name"
//                     className={inputStyle}
//                   />
//                   <label className={labelStyle}>Supplier Name *</label>
//                 </div>
//                 <div className="w-[47%]">
//                   <input
//                     type="email"
//                     name="supplier_email"
//                     placeholder="Enter supplier email"
//                     className={inputStyle}
//                   />
//                   <label className={labelStyle}>Supplier Email *</label>
//                 </div>
//               </div>
//               <div className="flex items-center justify-between gap-4">
//                 <div className="w-[47%]">
//                   <input
//                     type="text"
//                     name="supplier_phonenumber"
//                     placeholder="Enter phone number"
//                     className={inputStyle}
//                   />
//                   <label className={labelStyle}>Phone Number</label>
//                 </div>
//                 <div className="w-[47%]">
//                   <input
//                     type="text"
//                     name="supplier_address"
//                     placeholder="Enter address"
//                     className={inputStyle}
//                   />
//                   <label className={labelStyle}>Address</label>
//                 </div>
//               </div>
//               <div className="flex gap-2 mt-3">
//                 <button
//                   type="button"
//                   onClick={createNewSupplier}
//                   className="h-10 px-4 text-sm font-semibold text-white bg-primary rounded-md hover:bg-opacity-90"
//                 >
//                   Add Supplier
//                 </button>
//                 <button
//                   type="button"
//                   onClick={() => setShowNewSupplierForm(false)}
//                   className="h-10 px-4 text-sm text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50"
//                 >
//                   Cancel
//                 </button>
//               </div>
//             </form>
//           </div>
//         )}
//       </div>

//       {/* Search Bar */}
//       <div className="flex items-center justify-between w-full mb-4">
//         <div className="w-full max-w-md">
//           <div className="relative">
//             <input
//               type="text"
//               placeholder="Search suppliers..."
//               value={searchInput}
//               onChange={handleSearchInput}
//               className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-yellow-500 text-sm"
//             />
//             <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
//               <svg
//                 className="w-4 h-4 text-gray-500"
//                 fill="currentColor"
//                 viewBox="0 0 20 20"
//                 xmlns="http://www.w3.org/2000/svg"
//               >
//                 <path d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"></path>
//               </svg>
//             </div>
//           </div>
//         </div>
//       </div>

//       {loading ? (
//         <div className="flex items-center justify-center w-full h-32">
//           <div className="flex items-center justify-center p-10 gap-x-2">
//             <div className="w-6 h-6 animate-spin border-2 border-yellow-500 border-t-transparent rounded-full"></div>
//             <p className="text-sm animate-pulse text-gray-600">Fetching suppliers...</p>
//           </div>
//         </div>
//       ) : !filteredSuppliers?.length ? (
//         <div className="flex items-center justify-center w-full h-32">
//           <p className="text-xl font-semibold text-center text-gray-600">
//             {searchInput ? "No matching suppliers found!" : "No suppliers found!"}
//           </p>
//         </div>
//       ) : (
//         <TableContainer className="h-auto max-h-[700px] overflow-y-scroll">
//           <Table stickyHeader aria-label="suppliers table" className="rounded-xl">
//             <TableHead>
//               <TableRow>
//                 <TableCell>
//                   <span className="font-semibold text-gray-500">Date Added</span>
//                 </TableCell>
//                 <TableCell align="left">
//                   <span className="font-semibold text-gray-500">Supplier</span>
//                 </TableCell>
//                 <TableCell align="left">
//                   <span className="font-semibold text-gray-500">Email</span>
//                 </TableCell>
//                 <TableCell align="left">
//                   <span className="font-semibold text-gray-500">Phone</span>
//                 </TableCell>
//                 <TableCell align="left">
//                   <span className="font-semibold text-gray-500">Actions</span>
//                 </TableCell>
//               </TableRow>
//             </TableHead>
//             <TableBody>
//               {filteredSuppliers.map((supplier) => (
//                 <TableRow key={supplier.id}>
//                   <TableCell>
//                     <span className="text-sm text-gray-600">{supplier.dateAdded}</span>
//                   </TableCell>
//                   <TableCell align="left">
//                     <div className="flex items-center gap-x-3">
//                       <span className="w-10 h-10 font-bold text-blue-600 bg-blue-100 border-gray-200 rounded-full flex items-center justify-center">
//                         {getInitials(supplier.name)}
//                       </span>
//                       <div className="flex flex-col">
//                         <span className="font-medium text-gray-900">{supplier.name}</span>
//                         <span className="text-sm text-gray-500">{supplier.email}</span>
//                       </div>
//                     </div>
//                   </TableCell>
//                   <TableCell align="left">
//                     <span className="text-sm text-gray-600">{supplier.email}</span>
//                   </TableCell>
//                   <TableCell align="left">
//                     <span className="text-sm text-gray-600">{supplier.phone}</span>
//                   </TableCell>
//                   <TableCell align="left">
//                     <button className="text-blue-600 hover:text-blue-700 text-sm font-medium">
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

// export default SupplierSection;